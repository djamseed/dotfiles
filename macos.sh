#!/bin/bash

set -euo pipefail

echo "Applying macOS defaults..."

# Ask for admin early (needed for some settings below)
if ! sudo -v; then
    echo "This script needs sudo. Aborting."
    exit 1
fi

###############################################################################
# Finder                                                                      #
###############################################################################

# Prefer tabs when opening documents
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"

# Quit Finder with ⌘Q, disable animations, show items on Desktop, default window = Home
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Advanced: no warnings on extension change / empty trash, search current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show ~/Library
chflags nohidden "${HOME}/Library"

# View: folders first, list view, show path bar, hide status bar
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false

# Desktop icon layout
defaults write com.apple.finder DesktopViewSettings '{ "IconViewSettings" = { "iconSize" = 80; "gridSpacing" = 100; "labelOnBottom" = 1; "arrangeBy" = "grid"; }; }'

# Hidden settings: spring loading, avoid .DS_Store on net/USB, open window on mount
defaults write -g com.apple.springing.enabled -int 1
defaults write -g com.apple.springing.delay -float 0
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Info panes: expand General, Open with, Sharing & Permissions
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# File handling QoL
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowItemInfo -bool true
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
defaults write com.apple.finder QLEnableTextSelection -bool true

###############################################################################
# Dock, Mission Control                                                       #
###############################################################################
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 48
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock expose-group-by-app -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1

# Hot corner: bottom-right = Desktop (0=none, 4=Desktop)
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# Reset Launchpad (keep wallpaper)
find "${HOME}/Library/Application Support/Dock" -maxdepth 1 -name "*-*.db" -delete || true

# Wipe default apps from Dock (useful on a clean setup)
defaults write com.apple.dock persistent-apps -array

###############################################################################
# Spotlight                                                                   #
###############################################################################
# Custom categories (note: Apple occasionally changes names; harmless if ignored)
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 1;"name" = "FONTS";}' \
    '{"enabled" = 0;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Optionally rebuild index (can take time)
killall mds >/dev/null 2>&1 || true
sudo mdutil -i on / >/dev/null 2>&1 || true
sudo mdutil -E / >/dev/null 2>&1 || true

###############################################################################
# Language & Region                                                           #
###############################################################################
defaults write NSGlobalDomain AppleLanguages -array "en-US"
defaults write NSGlobalDomain AppleLocale -string "en_MU@currency=MUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

###############################################################################
# Users & Groups / Login                                                      #
###############################################################################
# Fast user switching icon
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/User.menu"
defaults write NSGlobalDomain userMenuExtraStyle -int 2
# Guest login & password hints off
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -int 0
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

###############################################################################
# Security & Privacy                                                          #
###############################################################################
# Disable quarantine prompts (you can re-enable if desired)
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Require password immediately after sleep/screensaver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 60
# Firewall + stealth
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1
# Disable IR remote & captive portal assistant
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -int 0
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -int 0

###############################################################################
# Software Update                                                             #
###############################################################################
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Keyboard & Input                                                            #
###############################################################################
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Full keyboard access (tab through all controls)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Shortcuts: disable Mission Control bindings (IDs may change over releases; harmless if ignored)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "{ enabled = 0; }"

###############################################################################
# Trackpad                                                                    #
###############################################################################
# Tap to click + gestures
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

###############################################################################
# Sound / Boot                                                                #
###############################################################################
# Disable boot chime (may be ignored on some M-series configs)
sudo nvram SystemAudioVolume=" " || true

###############################################################################
# Network                                                                     #
###############################################################################
# Show VPN in menu bar + show time connected
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/VPN.menu"
defaults write com.apple.networkConnect VPNShowTime -int 1

###############################################################################
# Dictation                                                                   #
###############################################################################
defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 0

###############################################################################
# Date & Time / Clock                                                         #
###############################################################################
# 12-hour, no day-of-week
defaults write com.apple.menuextra.clock DateFormat -string 'h:mm'

###############################################################################
# Energy Saver / Power                                                        #
###############################################################################
sudo pmset -a autorestart 1
sudo pmset -a displaysleep 15
sudo pmset -a hibernatemode 0
sudo pmset -a lidwake 1
sudo pmset -a standbydelay 7200
sudo pmset -b sleep 5
sudo pmset -c sleep 0
sudo systemsetup -setcomputersleep Off >/dev/null 2>&1 || true
sudo systemsetup -setrestartfreeze on >/dev/null 2>&1 || true
sudo systemsetup -setwakeonnetworkaccess off >/dev/null 2>&1 || true

# Sleep image hacks (LEGACY on APFS / Apple Silicon) — guard to avoid failures
if [ -f /private/var/vm/sleepimage ]; then
    sudo rm /private/var/vm/sleepimage || true
    sudo touch /private/var/vm/sleepimage || true
    sudo chflags uchg /private/var/vm/sleepimage || true
fi

###############################################################################
# Sharing                                                                     #
###############################################################################
# Computer name (customize if you want)
sudo scutil --set ComputerName "ATHENA"
sudo scutil --set HostName "ATHENA"
sudo scutil --set LocalHostName "ATHENA"
# NetBIOS name (value from your original; adjust if desired)
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"
# Remote Apple events / remote login off
sudo systemsetup -setremoteappleevents off >/dev/null 2>&1 || true
sudo systemsetup -setremotelogin off >/dev/null 2>&1 || true

###############################################################################
# Time Machine                                                                #
###############################################################################
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Display / Screenshots                                                       #
###############################################################################
# Subpixel smoothing (may be ignored on modern displays)
defaults write NSGlobalDomain AppleFontSmoothing -int 1
# Screenshots
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
# Choose jpg (smaller) or png (lossless). Last one wins:
defaults write com.apple.screencapture type -string "jpg"
defaults write com.apple.screencapture name -string "Screenshot"
# Enable HiDPI modes (often on by default on Apple Silicon)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -int 1

###############################################################################
# Misc Hidden Settings                                                        #
###############################################################################
# Rebuild Launch Services
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Terminate inactive apps, don’t save to iCloud, expand panels, show control chars, faster resize, expand print panel
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
# Bluetooth audio bitpool (LEGACY, codec-specific)
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
# Crash reporter off
defaults write com.apple.CrashReporter DialogType -string "none"
# Help viewer non-floating
defaults write com.apple.helpviewer DevMode -bool true
# Quit Printer app on completion
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Don’t keep windows when quitting System Settings
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
# Reduce transparency
defaults write com.apple.universalaccess reduceTransparency -bool true
# Show host info on login screen
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
# Disable Bonjour multicast advertisements
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Contacts                                                                    #
###############################################################################
defaults write com.apple.AddressBook ABNameSortingFormat 'sortingFirstName sortingLastName'

###############################################################################
# Mail                                                                        #
###############################################################################
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"
defaults write com.apple.mail ConversationViewSortDescending -bool true
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
defaults write com.apple.mail DisableURLLoading -bool true

###############################################################################
# Messages                                                                    #
###############################################################################
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -int 0
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -int 0

###############################################################################
# Photos                                                                      #
###############################################################################
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# QuickTime                                                                   #
###############################################################################
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

###############################################################################
# Safari & WebKit                                                             #
###############################################################################
defaults write com.apple.Safari HomePage -string "about:blank"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari CanPromptForPushNotifications -bool false
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
# Java/script window policies (LEGACY on modern Safari; safe to set)
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
# UI
defaults write com.apple.Safari ShowFavoritesBar -bool false
defaults write com.apple.Safari ShowStatusBar -bool true
# Extra privacy
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

###############################################################################
# TextEdit                                                                    #
###############################################################################
defaults write com.apple.TextEdit RichText -bool false
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Transmission                                                                #
###############################################################################
defaults write org.m0k.transmission AutoSize -bool false
defaults write org.m0k.transmission AutoStartDownload -bool true
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
defaults write org.m0k.transmission BlocklistURL -string "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz"
defaults write org.m0k.transmission CheckDownload -bool false
defaults write org.m0k.transmission CheckQuit -bool false
defaults write org.m0k.transmission CheckRemove -bool true
defaults write org.m0k.transmission CheckRemoveDownloading -bool true
defaults write org.m0k.transmission CheckUpload -bool false
defaults write org.m0k.transmission DeleteOriginalTorrent -bool false
defaults write org.m0k.transmission DisplayProgressBarAvailable -bool true
defaults write org.m0k.transmission DownloadAsk -bool true
defaults write org.m0k.transmission DownloadAskManual -bool false
defaults write org.m0k.transmission DownloadAskMulti -bool false
defaults write org.m0k.transmission DownloadLocationConstant -bool false
defaults write org.m0k.transmission EncryptionRequire -bool true
defaults write org.m0k.transmission MagnetOpenAsk -bool false
defaults write org.m0k.transmission PeersTorrent -int 10
defaults write org.m0k.transmission PeersTotal -int 200
defaults write org.m0k.transmission PlayDownloadSound -bool false
defaults write org.m0k.transmission RandomPort -bool false
defaults write org.m0k.transmission SleepPrevent -bool true
defaults write org.m0k.transmission SmallView -bool true
defaults write org.m0k.transmission SpeedLimitDownloadLimit -int 2000
defaults write org.m0k.transmission SpeedLimitUploadLimit -int 1000
defaults write org.m0k.transmission SUEnableAutomaticChecks -bool false
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool false
defaults write org.m0k.transmission WarningDonate -bool false
defaults write org.m0k.transmission WarningLegal -bool false

###############################################################################
# Apply / Restart affected apps                                               #
###############################################################################
for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Mail" \
    "Messages" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission"; do
    killall "${app}" &>/dev/null || true
done

cat <<'EOF'

✅ Done. Some changes require log out / restart to fully apply.

Manual reminders (things Apple moved to System Settings panes or that don't have stable `defaults` keys):
  • Finder → Sidebar selections (Applications, Downloads, Pictures, Home, iCloud Drive, etc.)
  • General → Default web browser
  • Screen Saver source & style

EOF
