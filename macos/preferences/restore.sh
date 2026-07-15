#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${HOME}/.dotfiles-restore-backup/$(date +%Y%m%d-%H%M%S)/macos-preferences"
mkdir -p "$BACKUP_DIR"

cp -p "$HOME/Library/Preferences/.GlobalPreferences.plist" "$BACKUP_DIR/NSGlobalDomain.plist" 2>/dev/null || true
defaults export com.apple.dock "$BACKUP_DIR/com.apple.dock.plist" >/dev/null 2>&1 || true
defaults export com.apple.finder "$BACKUP_DIR/com.apple.finder.plist" >/dev/null 2>&1 || true
defaults export com.apple.screencapture "$BACKUP_DIR/com.apple.screencapture.plist" >/dev/null 2>&1 || true
defaults export com.lihaoyun6.QuickRecorder "$BACKUP_DIR/com.lihaoyun6.QuickRecorder.plist" >/dev/null 2>&1 || true
defaults export com.ethanbills.DockDoor "$BACKUP_DIR/com.ethanbills.DockDoor.plist" >/dev/null 2>&1 || true

defaults write NSGlobalDomain AppleKeyboardUIMode -int 0
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain AppleWindowTabbingMode -string always
defaults write NSGlobalDomain AppleActionOnDoubleClick -string Fill
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock minimize-to-application -bool false
defaults write com.apple.dock orientation -string bottom
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -float 32
defaults write com.apple.dock largesize -float 57
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder FXDefaultSearchScope -string SCev
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowPreviewPane -bool false
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool false
defaults write com.apple.screencapture style -string display
defaults write com.lihaoyun6.QuickRecorder frameRate -int 60
defaults write com.lihaoyun6.QuickRecorder recordHDR -bool false
defaults write com.lihaoyun6.QuickRecorder recordMic -bool true
defaults write com.ethanbills.DockDoor compactModeItemSize -int 2
defaults write com.ethanbills.DockDoor compactModeTitleFormat -string titleOnly
defaults write com.ethanbills.DockDoor disableImagePreview -bool false
defaults write com.ethanbills.DockDoor globalPaddingMultiplier -float 0.9
defaults write com.ethanbills.DockDoor previewHeight -float 81.25
defaults write com.ethanbills.DockDoor previewWidth -float 130
defaults write com.ethanbills.DockDoor uniformCardRadius -float 1
defaults write com.ethanbills.DockDoor windowPreviewSortOrder -string recentlyUsed

if [[ -f "$(dirname "$0")/symbolic-hotkeys.plist" ]]; then
  defaults export com.apple.symbolichotkeys "$BACKUP_DIR/com.apple.symbolichotkeys.plist" >/dev/null 2>&1 || true
  defaults import com.apple.symbolichotkeys "$(dirname "$0")/symbolic-hotkeys.plist"
fi

killall Dock >/dev/null 2>&1 || true
killall Finder >/dev/null 2>&1 || true
echo "macOS preferences restored; previous domains were exported to: $BACKUP_DIR"
