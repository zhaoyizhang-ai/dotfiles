#!/usr/bin/env ruby
# Export portable routing only; subscription credentials stay in the app directory.
require 'yaml'
require 'json'
require 'fileutils'
require 'open3'
require 'uri'

REPO = File.expand_path('..', __dir__)
PACKAGE = File.join(REPO, 'apps', 'clash-verge')
APP_DIR = File.join(Dir.home, 'Library', 'Application Support', 'io.github.clash-verge-rev.clash-verge-rev')
SOCKET = '/tmp/verge/verge-mihomo.sock'
CORE = '/Applications/Clash Verge.app/Contents/MacOS/verge-mihomo'
CORE_KEYS = %w[mixed-port mode allow-lan ipv6 log-level].freeze
VERGE_KEYS = %w[enable_system_proxy enable_tun_mode verge_mixed_port enable_auto_launch].freeze
RULE_TYPES = %w[DOMAIN DOMAIN-SUFFIX IP-CIDR IP-CIDR6 GEOSITE GEOIP].freeze

def read_yaml(path)
  YAML.safe_load(File.read(path), permitted_classes: [], permitted_symbols: [], aliases: true) || {}
end

def dump_yaml(path, data)
  File.write(path, YAML.dump(data))
end

def profile_file(name)
  raise 'Invalid profile filename' unless name.is_a?(String) && name.match?(/\A[\w.-]+\.yaml\z/)
  File.join(APP_DIR, 'profiles', name)
end

def context
  profiles = read_yaml(File.join(APP_DIR, 'profiles.yaml'))
  selected = profiles.fetch('items').find { |item| item['uid'] == profiles['current'] }
  raise 'Select an imported subscription in Clash Verge first' unless selected
  rule_uid = selected.fetch('option', {})['rules']
  rule_item = profiles['items'].find { |item| item['uid'] == rule_uid }
  raise 'The active subscription has no rules override; initialize it in Clash Verge first' unless rule_item
  [profile_file(rule_item.fetch('file')), profile_file(selected.fetch('file'))]
end

def rule_fields(rule)
  fields = rule.split(',')
  raise 'Unsupported routing rule in portable policy' unless RULE_TYPES.include?(fields[0]) && (3..4).cover?(fields.length)
  target_index = fields[-1] == 'no-resolve' ? -2 : -1
  [fields, target_index]
end

def core_api(method, path, data = nil)
  command = ['curl', '--fail', '--silent', '--show-error', '--max-time', '15',
             '--noproxy', '*', '--unix-socket', SOCKET, '-X', method]
  command += ['-H', 'Content-Type: application/json', '--data-binary', JSON.generate(data)] if data
  output, _errors, status = Open3.capture3(*command, 'http://localhost' + path)
  raise "Core API #{method} #{path} failed" unless status.success?
  output.empty? ? {} : JSON.parse(output)
end

def export_policy
  rule_path, = context
  prefix = read_yaml(rule_path).fetch('prepend', [])
  if prefix.empty?
    puts 'No custom routing to export; kept the existing portable policy.'
    return
  end
  portable = prefix.map do |rule|
    fields, target_index = rule_fields(rule)
    fields[target_index] = '__PROXY_GROUP__' unless %w[DIRECT REJECT].include?(fields[target_index])
    fields.join(',')
  end
  settings = {
    'core' => read_yaml(File.join(APP_DIR, 'config.yaml')).select { |key, _| CORE_KEYS.include?(key) },
    'verge' => read_yaml(File.join(APP_DIR, 'verge.yaml')).select { |key, _| VERGE_KEYS.include?(key) }
  }
  FileUtils.mkdir_p(PACKAGE)
  dump_yaml(File.join(PACKAGE, 'rules.yaml'), {'prepend' => portable, 'append' => [], 'delete' => []})
  dump_yaml(File.join(PACKAGE, 'settings.yaml'), settings)
  puts "Exported #{portable.length} portable rules and whitelisted proxy settings."
end

def restore_policy
  rule_path, subscription_path = context
  runtime_path = File.join(APP_DIR, 'clash-verge.yaml')
  running = File.socket?(SOCKET)
  original_rules = read_yaml(rule_path)
  runtime = File.file?(runtime_path) ? read_yaml(runtime_path) : nil
  subscription = read_yaml(subscription_path)
  effective = running && runtime ? runtime.fetch('rules', []) :
    Array(original_rules['prepend']) + Array(subscription['rules']) + Array(original_rules['append'])
  match = effective.find { |rule| rule.start_with?('MATCH,') }
  raise 'No MATCH route found; cannot infer the active outbound group' unless match
  outbound = match.split(',')[1]
  proxy_path = '/proxies/' + URI.encode_www_form_component(outbound).gsub('+', '%20')
  previous_proxy = running ? core_api('GET', proxy_path)['now'] : nil
  policy = read_yaml(File.join(PACKAGE, 'rules.yaml')).fetch('prepend').map do |rule|
    rule_fields(rule)
    rule.gsub('__PROXY_GROUP__', outbound)
  end
  settings = read_yaml(File.join(PACKAGE, 'settings.yaml'))
  replacements = {}
  originals = {}
  backup = File.join(Dir.home, '.dotfiles-restore-backup', Time.now.strftime('%Y%m%d-%H%M%S') + "-#{Process.pid}", 'clash-verge')
  FileUtils.mkdir_p(backup, mode: 0700)

  original_rules['prepend'] = policy + (Array(original_rules['prepend']) - policy)
  original_rules['delete'] = Array(original_rules['delete']) - policy
  replacements[rule_path] = original_rules
  {'config.yaml' => ['core', CORE_KEYS], 'verge.yaml' => ['verge', VERGE_KEYS]}.each do |name, (section, allowed)|
    path = File.join(APP_DIR, name)
    replacements[path] = read_yaml(path).merge(settings.fetch(section).select { |key, _| allowed.include?(key) })
  end

  if running
    raise 'Running core cannot be validated: missing runtime or Mihomo executable' unless runtime && File.executable?(CORE)
    runtime['rules'] = policy + (runtime.fetch('rules', []) - policy)
    runtime.merge!(settings.fetch('core').select { |key, _| CORE_KEYS.include?(key) })
    runtime['tun'] = (runtime['tun'] || {}).merge('enable' => settings.fetch('verge').fetch('enable_tun_mode'))
    replacements[runtime_path] = runtime
  end
  replacements.each do |path, data|
    originals[path] = File.binread(path)
    destination = File.join(backup, File.basename(path))
    FileUtils.cp(path, destination)
    File.chmod(0600, destination)
    candidate = destination + '.candidate'
    dump_yaml(candidate, data)
    File.chmod(0600, candidate)
  end
  if running
    _output, _errors, status = Open3.capture3(CORE, '-t', '-d', APP_DIR, '-f', File.join(backup, 'clash-verge.yaml.candidate'))
    raise 'Mihomo rejected the candidate; local configuration was not changed' unless status.success?
  end
  raise 'Configuration changed during preparation; retry after the app settles' if originals.any? { |path, bytes| File.binread(path) != bytes }

  begin
    replacements.each do |path, data|
      temporary = path + ".dotfiles-#{Process.pid}.tmp"
      dump_yaml(temporary, data)
      File.chmod(File.stat(path).mode & 0777, temporary)
      File.rename(temporary, path)
    end
    if running
      core_api('PUT', '/configs', {'path' => runtime_path})
      actual = core_api('GET', '/rules').fetch('rules')
      raise 'Effective routing verification failed' unless actual.length == runtime['rules'].length && actual.first['payload'] == policy.first.split(',')[1]
      raise 'Selected proxy changed while restoring' unless core_api('GET', proxy_path)['now'] == previous_proxy
    end
  rescue StandardError
    originals.each { |path, bytes| File.binwrite(path, bytes) }
    core_api('PUT', '/configs', {'path' => runtime_path}) if running
    raise
  end
  puts "Restored #{policy.length} rules to the current subscription; backup: #{backup}"
  puts(running ? 'The running core has reloaded the routing.' : 'Start Clash Verge to apply the saved system proxy settings and routing.')
end

begin
  command = ARGV.shift
  raise 'Usage: ruby scripts/clash-routing.rb export|restore [--if-configured]' unless %w[export restore].include?(command)
  ready = File.file?(File.join(APP_DIR, 'profiles.yaml'))
  if ready
    profiles = read_yaml(File.join(APP_DIR, 'profiles.yaml'))
    selected = Array(profiles['items']).find { |item| item['uid'] == profiles['current'] }
    ready = selected && selected.fetch('option', {})['rules']
  end
  if !ready && ARGV.include?('--if-configured')
    puts 'Clash Verge is not configured; import/select a subscription, then run ruby scripts/clash-routing.rb restore.'
    exit 0
  end
  command == 'export' ? export_policy : restore_policy
rescue StandardError => error
  warn "Clash routing: #{error.message}"
  exit 1
end
