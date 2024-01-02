#!/usr/bin/env bash

# Enable dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleAccentColor -string "-1"
defaults write NSGlobalDomain AppleHighlightColor -string \
    "0.847059 0.847059 0.862745 Graphite"

# Prefer Finder tabs: Dock -> Prefer tabs when opening documents
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"

# Finder, Preferences, General
# [x] Quit Finder with ⌘ + Q
# [x] Disable animations
# Show these items on the desktop:
#   [x] External disks
#   [x] Connected servers
#   [x] Removable media
# New Finder windows show: ($HOME)
defaults write com.apple.finder QuitMenuItem -int 1
defaults write com.apple.finder DisableAllAnimations -int 1
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -int 1
defaults write com.apple.finder ShowMountedServersOnDesktop -int 1
defaults write com.apple.finder ShowRemovableMediaOnDesktop -int 1
defaults write com.apple.finder NewWindowTarget 'PfHm'
defaults write com.apple.finder NewWindowTargetPath "'file://$HOME'"

# Finder, Preferences, Advanced
# [ ] Show warning before changing an extension
# [ ] Show warning before emptying the Trash
# When performing a search: [Search the Current Folder]
defaults write com.apple.finder FXEnableExtensionChangeWarning -int 0
defaults write com.apple.finder WarnOnEmptyTrash -int 0
defaults write com.apple.finder FXDefaultSearchScope 'SCcf'

# Finder, Hidden Settings
# [x] Show ~/Library folder
chflags nohidden ~/Library

# Finder, View
# [x] Sort folders first
# View Style: [List]
# [x] Show Path Bar
# [ ] Show Status Bar.
defaults write com.apple.finder _FXSortFoldersFirst -int 1
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -int 1
defaults write com.apple.finder ShowStatusBar -int 0

# Finder, View, Show View Options (Desktop)
# Icon size: 80
# Grid spacing: 100
# Label position: [x] Bottom
# Sort by: [Grid]
defaults write com.apple.finder DesktopViewSettings '{ "IconViewSettings" = { "iconSize" = 80; "gridSpacing" = 100; "labelOnBottom" = 1; "arrangeBy" = "grid"; }; }'

# Finder, Hidden settings
# Spring loading for directories: [x], delay 0
# Avoid creating .DS_Store files on
#   [x] Network volumes
#   [x] USB volumes
# [x] Open a new Finder window when a volume is mounted
defaults write -g com.apple.springing.enabled -int 1
defaults write -g com.apple.springing.delay -float 0
defaults write com.apple.desktopservices DSDontWriteNetworkStores -int 1
defaults write com.apple.desktopservices DSDontWriteUSBStores -int 1
defaults write com.apple.finder OpenWindowForNewRemovableDisk -int 1
defaults write com.apple.frameworks.diskimages auto-open-ro-root -int 1
defaults write com.apple.frameworks.diskimages auto-open-rw-root -int 1

# Finder, File Info Pane:
# Expand: ["General", "Open with", "Sharing & Permissions"]
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# System Preferences, General
# Show scroll bars: [x] Automatic
# Highlight colour: [Red]
# Sidebar icon size: [Medium]
defaults write -g AppleShowScrollBars 'Automatic'
defaults write -g AppleHighlightColor -string "0.988235 0.32941 0.35686"
defaults write -g NSTableViewDefaultSizeMode -int 2

# System Preferences, Dock
# Size: 40
# [x] Magnification: 48
# Window effect: [Scale]
# [x] Automatically show/hide the dock
# [x] Show indicators for opening apps in the dock
defaults write com.apple.dock tilesize -float 40
defaults write com.apple.dock magnification -int 1
defaults write com.apple.dock largesize -float 48
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -int 1
defaults write com.apple.dock autohide -int 1
defaults write com.apple.dock show-process-indicators -int 1

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Wipe default macOS app icons from the Dock
# Useful for setting up new Macs. Optionally relaunch dock with `killall Dock`.
defaults write com.apple.dock persistent-apps -array

# System Preferences, Mission Control
# [ ] Rearrange spaces based on most recent use
# Expose animation duration: 0.1
# [ ] Dashboard
# [x] Group windows by application
# [ ] Show dashboard on spaces
defaults write com.apple.dock mru-spaces -int 0
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dashboard mcx-disabled -int 1
defaults write com.apple.dock expose-group-by-app -int 1
defaults write com.apple.dock dashboard-in-overlay -int 1

# System Preferences, Spotlight
# [ ] Do not index any volumes
# Indexing: [Applications, System Preferences, Directories, PDFs, Fonts]
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

# Load new settings before rebuilding the index
killall mds >/dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / >/dev/null
# Rebuild the index from scratch
sudo mdutil -E / >/dev/null

# System Preferences, Language & Region, General
# Preferred Language: [en-US]
defaults write -g AppleLanguages -array "en-US"

# System Preferences, Language & Region, Advanced
# Currency: [Mauritian Rupee]
# Measurement units: [x] Metrics, Centimeters
defaults write -g AppleLocale -string "en_MU@currency=MUR"
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -int 1

# System Preferences, Users & Groups, Login Options
# [x] Show fast user switching menu as [Icon]
# [ ] Guest Login
# [ ] Password hints
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/User.menu"
defaults write -g userMenuExtraStyle -int 2
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -int 0
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

# System Preferences, Security & Privacy, General
# [ ] Disable the quarantine
# [x] Require password [1 minute] after sleep or screen saver begins.
# [ ] Disable Gatekeeper (Apps can be downloaded from 'Anywhere')
defaults write com.apple.LaunchServices LSQuarantine -int 0
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 60 # 300 Seconds = 1 minute.
# sudo spctl --master-disable

# System Preferences, Security & Privacy, Firewall
# Firewall: [x], specific services
# [x] Stealth mode
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1

# System Preferences, Security & Privacy, Privacy
# [ ] IR remote control
# [ ] Wifi captive portal
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -int 0
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -int 0

# System Preferences, Software Updates, Advance
# [x] Automatic update checks
# Automatic update frequency: [Daily]
# [x] Download new updates in background
# [x] Install system data files and security updates
# [x] App auto-update
# [x] Reboot on macOS updates
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -int 1
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.commerce AutoUpdate -int 1
defaults write com.apple.commerce AutoUpdateRestartRequired -int 1

# System Preferences, Keyboard, Keyboard
# Key Repeat: 2 * 15ms = 30ms
# Delay Until Repeat: 25 * 15ms = 375ms
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 25

# System Preferences, Keyboard, Text
# [ ] Correct spelling automatically
# [ ] Capitalise words automatically
# [ ] Add period with double-space
# [ ] Use smart quotes and dashes
defaults write -g NSAutomaticSpellingCorrectionEnabled -int 0
defaults write -g NSAutomaticCapitalizationEnabled -int 0
defaults write -g NSAutomaticPeriodSubstitutionEnabled -int 0
defaults write -g NSAutomaticQuoteSubstitutionEnabled -int 0
defaults write -g NSAutomaticDashSubstitutionEnabled -int 0

# System Preferences, Keyboard, Shortcuts
# Mission Control:
#   [ ] Mission Control
#   [ ] Application Windows
#   [ ] Move left a space
#   [ ] Move right a space
#   [ ] Switch to desktop (n)
# Full Keyboard Access: [x] All controls
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{ enabled = 0; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "{ enabled = 0; }"
defaults write -g AppleKeyboardUIMode -int 3

# System Preferences, Trackpad, Point & Click
# [x] Tap to click
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1

# System Preferences, Trackpad, More Gestures
# [x] Swipe between pages
# [x] App Expose
defaults write -g AppleEnableSwipeNavigateWithScrolls -int 1
defaults write com.apple.dock showAppExposeGestureEnabled -int 1

# System Preferences, Sound
# [ ] Sound effect on boot
sudo nvram SystemAudioVolume=" "

# System Preferences, Network, (VPN)
# [x] Show VPN status in menu bar
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/VPN.menu"

# Menu Bar, VPN status
# [x] Show Time Connected
defaults write com.apple.networkConnect VPNShowTime -int 1

# System Preferences, Dictation & Speech, Dictation
# Shortcut: [Off]
defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 0

# System Preferences, Date & Time, Clock
# [ ] Show AM/PM
# [ ] Show the day of the week
defaults write com.apple.menuextra.clock DateFormat 'h:mm'

# System Preferences, Energy Saver
# [x] Automatic restart on power loss
# Display sleep: 15 mins
# [ ] Hibernate
# [x] Lid wakeup
# Standby delay: 2 hrs
# Machine sleep on battery: 5 mins
# [ ] Sleep while charging
# [ ] Sleep mode
# [x] Restart automatically on system freeze
# [ ] Wake-on LAN
sudo pmset -a autorestart 1
sudo pmset -a displaysleep 15
sudo pmset -a hibernatemode 0
sudo pmset -a lidwake 1
sudo pmset -a standbydelay 7200
sudo pmset -b sleep 5
sudo pmset -c sleep 0
sudo systemsetup -setcomputersleep Off >/dev/null
sudo systemsetup -setrestartfreeze on
sudo systemsetup -setwakeonnetworkaccess off

# Remove the sleep image file to save disk space
sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /private/var/vm/sleepimage

# System Preferences, Sharing
# Computer name: [YOUR COMPUTER NAME]
# [ ] Remote Apple events
# [ ] Remote login
sudo scutil --set ComputerName "ATHENA"
sudo scutil --set HostName "ATHENA"
sudo scutil --set LocalHostName "ATHENA"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"
sudo systemsetup -setremoteappleevents off
sudo systemsetup -setremotelogin off

# System Preferences, Time Maching
# [ ] Use new hard drives as backup drives
# [ ] Local Time Machine backups
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Screenshots
# [x] Subpixel font rendering on non-Apple LCDs
# [ ] Shadow in screenshots
# Screenshot location: [Desktop]
# Screenshot type: [PNG]
# [x] HiDPI display modes (requires restart)
defaults write -g AppleFontSmoothing -int 1
defaults write com.apple.screencapture disable-shadow -int 1
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -int 1

# Other Hidden Settings
# Remove duplicates in: [Open With Menu]
# [x] Automatic termination of inactive apps
# [ ] Save new files to iCloud
# [x] Expand save panel
# [x] Display ASCII control characters
# [ ] Over-the-top focus ring animation
# Window resize speed: 0.001
# [x] Expand print panel
# Bluetooth sound quality: 40
# Crash reporter: [none]
# [x] Non-floating help viewer
# [x] Quit Printer app once print job completes
# [x] System-wide resume
# [x] Menu transparency
# Login screen info: [HostName]
# [ ] Bonjour multicast advertisements
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
defaults write -g NSDisableAutomaticTermination -int 1
defaults write -g NSDocumentSaveNewDocumentsToCloud -int 0
defaults write -g NSNavPanelExpandedStateForSaveMode -int 1
defaults write -g NSNavPanelExpandedStateForSaveMode2 -int 1
defaults write -g NSTextShowsControlCharacters -int 1
defaults write -g NSUseAnimatedFocusRing -int 0
defaults write -g NSWindowResizeTime -float 0.001
defaults write -g PMPrintingExpandedStateForPrint -int 1
defaults write -g PMPrintingExpandedStateForPrint2 -int 1
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
defaults write com.apple.CrashReporter DialogType -string "none"
defaults write com.apple.helpviewer DevMode -int 1
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -int 1
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -int 0
defaults write com.apple.universalaccess reduceTransparency -int 1
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Activity Monitor, Network
# Dock Icon: [CPU Usage]
# [x] Show main window
# Network Graph Type: [DATA]
# View: [All Processes]
# Sort By: [CPU Usage]
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor OpenMainWindow -int 1
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Contacts, Preferences, General
# Sort By: [Given Name]
defaults write com.apple.AddressBook ABNameSortingFormat 'sortingFirstName sortingLastName'

# iTerm2
# [ ] Prompt on quit
defaults write com.googlecode.iterm2 PromptOnQuit -int 0

# Mail

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

# Most recent first
defaults write com.apple.mail ConversationViewSortDescending -bool true

# Display emails in threaded mode, sorted by date (oldest at the top)
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable remote content
defaults write com.apple.mail DisableURLLoading -bool true

# Messages
# [ ] Smart quotes
# [ ] Continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -int 0
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -int 0

# Photos
# [ ] Open automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -int 1

# QuickTime
# [x] Autoplay vidoes on launch
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -int 1

# Safari, Preferences, General
# Homepage: [Blank page]
# [ ] Open "safe" files after downloading
defaults write com.apple.Safari HomePage -string "about:blank"
defaults write com.apple.Safari AutoOpenSafeDownloads -int 0

# Safari, Preferences, Security
# [x] Warn when visiting fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -int 1

# Safari, Preferences, Privacy
# Website tracking: [x] Ask websites not to track me
# Hidden:
#     [ ] Don't send queries to Apple
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -int 1
defaults write com.apple.Safari UniversalSearchEnabled -int 0
defaults write com.apple.Safari SuppressSearchSuggestions -int 1

# Safari, Preferences, Notifications
# [ ] Allow websites to ask for permission to send push notifications
defaults write com.apple.Safari CanPromptForPushNotifications -int 0

# Safari, Preferences, Advanced
# Smart Search Field: [x] Show full website address
# [x] Enable Develop menu in menu bar
# [x] Enable web inspector
# [x] Enable web inspector in context menu on webpages
defaults write com.apple.Safari ShowFullURLInSmartSearchField -int 1
defaults write com.apple.Safari IncludeDevelopMenu -int 1
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -int 1
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -int 1
defaults write NSGlobalDomain WebKitDeveloperExtras -int 1

# Safari, Preferences, Extensions
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -int 1

# Safari, Preferences, Hidden
# [ ] Java
# [ ] JavaScript can open popups
defaults write com.apple.Safari WebKitJavaEnabled -int 0
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -int 0
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -int 0
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -int 0
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -int 0

# Safari, Bookmark
defaults write com.apple.Safari ShowFavoritesBar -int 0

# Safari, View
# [x] Show Status Bar
defaults write com.apple.Safari ShowStatusBar -int 1

# TextEdit
# [ ] Rich Text format
# Encoding: [UTF-8]
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Transmission
defaults write org.m0k.transmission AutoSize -bool false
defaults write org.m0k.transmission AutoStartDownload -bool true
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
defaults write org.m0k.transmission BlocklistURL -string \
    "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz"
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

# Kill affected applications
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
    killall "${app}" &>/dev/null
done

cat <<EOF

Done.  Note that some of these changes require a restart to take effect.  Here are some more defaults that need to be set manually:

    Finder, Preferences, Sidebar
        [ ] Recents
        [x] AirDrop
        [x] Applications
        [x] Downloads
        [ ] Movies
        [ ] Music
        [x] Pictures
        [x] ($HOME)
        [x] iCloud Drive
        [x] Desktop
        [ ] Documents
        [ ] (this mac)
        [x] Hard disks
        [x] External disks
        [x] CDs, DVDs, and iPods
        [ ] Bonjour computers
        [x] Connected servers
        [x] Recent Tags

    System Preferences, General
        Click in scroll bar: [Jump to the spot that's click]
        Default web browser: [Firefox]

    System Preferences, Desktop & Screen Saver, Screen Saver
        [Shifting Tiles]
        Source: [National Geographic]
        [x] Shuffle slide order

EOF
