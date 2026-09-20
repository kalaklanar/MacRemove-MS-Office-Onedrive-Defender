#!/bin/zsh
noglob

## VARIABLES ##
APPARRAY=(
    "Microsoft Word"
    "Microsoft Excel"
    "Microsoft PowerPoint"
    "Microsoft Outlook"
    "Microsoft OneNote"
    "Microsoft Teams"
    "OneDrive"
    "Microsoft AutoUpdate"
    "Microsoft Defender"
    "Microsoft Defender Shim.app"
)

## FORCE QUIT RUNNING MICROSOFT APPLICATIONS ##
echo "Close running Office applications, OneDrive, and Microsoft Defender"
for APP in "${APPARRAY[@]}"
do
    if pgrep -x "$APP" > /dev/null; then
        echo "Application $APP is running. Quitting application now..."
        osascript -e "quit app \"$APP\""
        sleep 2
    fi
    if pgrep -x "$APP" > /dev/null; then
        echo "Application $APP did not quit with osascript. Killing application now..."
        pkill -x "$APP"
    fi
    if pgrep -x "$APP" > /dev/null; then
        echo "Application $APP still did not quit. Killing application with sudo now..."
        sudo pkill -x "$APP"
    fi
done

for APP in "${APPARRAY[@]}"
do
    stillrunning=$(sudo pgrep -x "$APP")
    while [[ "$stillrunning" ]]; do
    echo "Application $APP still did not quit. Killing application with sudo now..."
    echo "You may want to check at the GUI to see what is blocking $APP"
    sudo kill "$stillrunning"
    echo "sleeping to allow time to quit $APP"
    stillrunning=$(sudo pgrep -x "$APP")
    done
done


## DETERMINE IF MICROSOFT APPLICATIONS ARE STILL RUNNING. IF SO, EXIT SCRIPT ##
echo "Determine what Office products, OneDrive, or Microsoft Defender are currently running..."
MicrosoftRunning=$(pgrep -l -f "Microsoft|OneDrive")
if [ -z "$MicrosoftRunning" ]; then
    echo "No Microsoft applications are running. Continue removal script."
else
    echo "Microsoft applications are still running. Exiting script."
    echo "$MicrosoftRunning"
    exit 0
fi

## REMOVE OFFICE AND ONEDRIVE ICONS FROM DOCK ##
if command -v dockutil >/dev/null 2>&1; then
    for APP in "${APPARRAY[@]}"
    do
        dockutil --allhomes --remove "$APP"
    done
fi

## REMOVE APPLICATIONS FROM "/APPLICATIONS/"
for APP in "${APPARRAY[@]}"
do
    sudo rm -rf "/Applications/${APP}.app"
done

## REMOVE SUPPORTING OFFICE FILES FROM SYSTEM LIBRARY ##
sudo rm -rf "/Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist"
sudo rm -rf "/Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist"
sudo rm -rf "/Library/LaunchDaemons/com.microsoft.onedriveupdaterdaemon.plist"
sudo rm -rf "/Library/LaunchAgents/com.microsoft.update.agent.plist"
sudo rm -rf "/Library/PrivilegedHelperTools/com.microsoft.office.licensingV2.helper"
sudo rm -rf "/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper"
sudo rm -rf "/Library/Preferences/com.microsoft.office.licensingV2.plist"
sudo rm -f "/Library/Preferences/com.microsoft.autoupdate2.plist"

## REMOVE MICROSOFT DEFENDER FILES FROM SYSTEM LIBRARY ##
sudo rm -rf "/Library/Application Support/Microsoft/Defender"
sudo rm -rf "/Library/LaunchDaemons/com.microsoft.wdav.daemon.plist"
sudo rm -rf "/Library/LaunchDaemons/com.microsoft.wdav.uninstall.plist"
sudo rm -rf "/Library/LaunchAgents/com.microsoft.wdav.tray.plist"
sudo rm -rf "/Library/Preferences/com.microsoft.wdav.plist"

## REMOVE ONEDRIVE BACKGROUND PROCESSES AND FILES ##
sudo rm -rf "/Library/LaunchAgents/com.microsoft.OneDrive*"
sudo rm -rf "/Library/LaunchAgents/com.microsoft.SyncReporter.plist"
sudo rm -rf "/Library/LaunchDaemons/com.microsoft.OneDrive*"
sudo rm -rf "/Library/PrivilegedHelperTools/com.microsoft.OneDrive*"

## REMOVE LOG FILES
sudo rm -fr "/Library/Logs/Microsoft"

## REMOVE SUPPORTING OFFICE, DEFENDER, AND ONEDRIVE FILES FROM END USER LIBRARIES ##
for USER_HOME in /Users/*
do
    USER_NAME=$(basename "$USER_HOME")
    if [ "$USER_NAME" != "Shared" ] && [ "$USER_NAME" != "Deleted Users" ]; then
        sudo rm -rf "$USER_HOME/Library/Caches/com.microsoft.SharePoint-mac/"
        sudo rm -rf "$USER_HOME/Library/Caches/com.microsoft.autoupdate.fba/"
        sudo rm -rf "$USER_HOME/Library/Caches/com.microsoft.autoupdate2.fba/"
        sudo rm -rf "$USER_HOME/Library/Caches/com.microsoft.SyncReporter/"
        sudo rm -rf "$USER_HOME/Library/Caches/com.microsoft.wdav.shim/"
        sudo rm -rf "$USER_HOME/Library/Daemon Containers/25CA0631-ECAC-4928-A48F-DBAA223A4A91/Data/SpinTracer/com.microsoft.Word"
        sudo rm -rf "$USER_HOME/Library/Daemon Containers/25CA0631-ECAC-4928-A48F-DBAA223A4A91/Data/SpinTracer/com.microsoft.Excel"
        sudo rm -rf "$USER_HOME/Library/Group Containers/UBF8T346G9.Office/"
        sudo rm -rf "$USER_HOME/Library/Application Support/FileProvider/com.microsoft.OneDrive.FileProvider"
        sudo rm -rf "$USER_HOME/Library/Application Support/Microsoft AutoUpdate"
        sudo rm -rf "$USER_HOME/Library/Application Support/Microsoft/Defender"
        sudo rm -rf "$USER_HOME/Library/Application Support/Microsoft Defender Shim"
        sudo rm -rf "$USER_HOME/Library/Application Support/Microsoft Update Assistant"
        sudo rm -rf "$USER_HOME/Library/Application Support/com.microsoft.SharePoint-mac"
        sudo rm -rf "$USER_HOME/Library/Application Support/OneDrive"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.errorreporting"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Excel"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Excel.widgetextension"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Microsoft-Mashup-Container"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.OneDrive.FileProvider"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.OneDrive.FinderSync"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.OneDriveLauncher"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.onenote.mac.shareextension"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.openxml.excel.app"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Outlook"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Outlook.CalendarWidget"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Powerpoint"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Powerpoint.widgetextension"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.SkyDriveLauncher"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Word.widgetextension"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/com.microsoft.Word"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/UBF8T346G9.com.microsoft.entrabroker"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/UBF8T346G9.com.microsoft.oneauth"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/UBF8T346G9.com.microsoft.teams"
        sudo rm -rf "$USER_HOME/Library/Application Scripts/UBF8T346G9.group.com.microsoft.shared"
        sudo rm -rf "$USER_HOME/Library/Application Support/CloudDocs/session/containers/iCloud.com.microsoft.skype.teams.plist"
        sudo rm -rf "$USER_HOME/Library/Application Support/CloudDocs/session/containers/iCloud.com.microsoft.Office.Word"
        sudo rm -rf "$USER_HOME/Library/Application Support/CloudDocs/session/containers/iCloud.com.microsoft.Office.Word.plist"
        sudo rm -rf "$USER_HOME/Library/Application Support/CloudDocs/session/containers/iCloud.com.microsoft.skype.teams"
        sudo rm -rf "$USER_HOME/Library/Caches/com.microsoft.OneDrive*"
        sudo rm -rf "$USER_HOME/Library/Containers/com.microsoft.*"
        sudo rm -rf "$USER_HOME/Library/Cookies/com.microsoft.*"
        sudo rm -rf "$USER_HOME/Library/Group Containers/UBF8T346G9.*"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.OneDriveUpdater.binarycookies"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.SharePoint-mac"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.autoupdate.fba"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.OneDrive.binarycookies"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.OneDriveStandaloneUpdater"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.autoupdate2"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.OneDrive"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.SyncReporter.binarycookies"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.wdav.shim"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.SharePoint-mac.binarycookies"
        sudo rm -rf "$USER_HOME/Library/com.microsoft.OneDriveUpdater"
        sudo rm -rf "$USER_HOME/Library/Logs/OneDrive"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.autoupdate.fba.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.autoupdate2.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.SharePoint-mac.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.OneDrive.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.OneDriveUpdater.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.OneDriveStandaloneUpdater.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.wdav.shim.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.office.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.Word.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.wdav.plist"
        sudo rm -rf "$USER_HOME/Library/Preferences/com.microsoft.OneDriveUpdater.plist"
        sudo rm -rf "$USER_HOME/Library/WebKit/com.microsoft.OneDrive"
        sudo rm -rf "$USER_HOME/Library/WebKit/com.microsoft.OneDrive*"
        sudo rm -rf "$USER_HOME/Library/WebKit/Databases/___IndexedDB/com.microsoft.OneDrive"
        if [[ -d "$USER_HOME/Library/CloudStorage/" ]]; then
            sudo find "$USER_HOME/Library/CloudStorage/" -name "OneDrive*" -type d >/dev/null 2>&1 | \
            while read i; do
                echo "really cloud storage deleting:::${i}:::"
                sudo rm -fr "$i"
            done
        fi
        if [[ -d "$USER_HOME/Library/Group Containers/UBF8T346G9.OneDriveStandaloneSuite/" ]]; then
        sudo find "$USER_HOME/Library/Group Containers/UBF8T346G9.OneDriveStandaloneSuite/" -name "OneDrive*" -type d >/dev/null 2>&1 | \
        while read i; do
            echo "really group containers deleting:::${i}:::"
            sudo rm -fr "$i"
        done
        fi
        if [[ -d "$USER_HOME/Library/HTTPStorages/" ]]; then
        sudo find "$USER_HOME/Library/HTTPStorages/" -name "com.microsoft*" -type d >/dev/null 2>&1 | \
            while read i; do
            echo "really httpstorage deleting:::${i}:::"
            sudo rm -fr "$i"
            done
        fi
    fi
done

echo "Microsoft Office, Microsoft Defender, and OneDrive removal script has completed."
