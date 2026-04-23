# Homebrew 配置（清华镜像）
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_NO_AUTO_UPDATE=true

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

. /opt/homebrew/etc/profile.d/autojump.sh

alias cc='source ~/claude_env.sh && claude --dangerously-skip-permissions'

# --- Solarized prompt (ported from mathiasbynens/.bash_prompt) ---

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' on %F{61}%b%f%u%c'
zstyle ':vcs_info:git:*' actionformats ' on %F{61}%b%f %F{red}(%a)%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{33}[!]%f'
zstyle ':vcs_info:git:*' stagedstr ' %F{64}[+]%f'

setopt PROMPT_SUBST

PROMPT='
%F{166}%n%f %F{15}at%f %F{136}%m%f %F{15}in%f %F{64}%~%f${vcs_info_msg_0_}
%F{15}$ %f'

# --- ls colors (macOS) ---
export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
alias ls="command ls -G"
alias l="ls -lF"
alias la="ls -lAF"
alias lsd="ls -lF | grep '^d'"

# colored grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
