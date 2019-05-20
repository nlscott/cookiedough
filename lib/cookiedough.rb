require "cookiedough/version"
require 'CFPropertyList'
require 'etc'

module CookieDough
    CURRENTUSER=Etc.getlogin

    #a list of default apps installed by the base macOS 10.12 system
    BASEAPPS = [ "App Store.app", "Automator.app", "Calculator.app","Calendar.app", "Chess.app",
        "Contacts.app", "Dashboard.app", "Dictionary.app", "DVD Player.app", "FaceTime.app",
        "Font Book.app", "Game Center.app", "iBooks.app", "Image Capture.app","iTunes.app",
        "Launchpad.app", "Mail.app", "Maps.app", "Messages.app", "Mission Control.app", "Notes.app",
        "Photo Booth.app", "Photos.app", "Preview.app", "QuickTime Player.app", "Reminders.app", "Safari.app",
        "Stickies.app", "System Preferences.app", "TextEdit.app", "Time Machine.app", "Utilities", "Siri.app",
        "Books.app", "Home.app", "News.app", "Stocks.app", "Pages.app", "VoiceMemos.app" ]

    #list entries in /Applications folder
    def self.list_apps
        apps = []
        Dir.entries("/Applications").each do |appname|
            if !appname.start_with?(".")
                apps.push(appname)
            end
        end
        return apps
    end

    #returns a list of apps installed by users ... minus the baseapps
    def self.user_installed_apps
        user_installed = []
        for x in list_apps
            if !CookieDough::BASEAPPS.include?(x)
                user_installed.push(x)
            end
        end
        return user_installed
    end

    #list of apps and version numbers
    def self.all_app_versions
        apps_to_check = []
        app_versions = []

        Dir.entries("/Applications").each do |appname|
            if appname.end_with?(".app")
                apps_to_check.push(appname)
            end
        end

        for app in apps_to_check
            if File.file?("/Applications/#{app}/Contents/Info.plist")
                begin
                    plist = CFPropertyList::List.new(:file => "/Applications/#{app}/Contents/Info.plist")
                    results=CFPropertyList.native_types(plist.value)
                rescue
                   puts "Error: misformed XML for '#{app}'"
                else
                    app_versions.push("#{app} = #{results['CFBundleShortVersionString']}")
                end
            end
        end
        check=[]
        Dir.entries("/Applications").each do |appname|
            if File.directory?("/Applications/#{appname}")
                if !appname.end_with?(".app")
                    if !appname.start_with?(".")
                        check.push(appname)
                    end
                end
            end
        end
        check.delete("Utilities")

        direcotries=[]
        check.each do |appname|
            Dir.entries("/Applications/#{appname}").each do |app|
                if app.end_with?(".app")
                    if File.exist?("/Applications/#{appname}/#{app}/Contents/Info.plist")
                        begin
                            plist = CFPropertyList::List.new(:file => "/Applications/#{appname}/#{app}/Contents/Info.plist")
                            results=CFPropertyList.native_types(plist.value)
                        rescue
                           puts "Error: misformed XML for '#{appname}/#{app}'"
                        else
                            app_versions.push("#{appname}/#{app} = #{results['CFBundleShortVersionString']}")
                        end
                    end

                end
            end
        end
        return app_versions.sort
    end

    #list a single app version but suppling a pathname to an app
    def self.app_version(appname)
        if File.exist?("/Applications/#{appname}")
            if File.exist?("/Applications/#{appname}/Contents/Info.plist")
                plist = CFPropertyList::List.new(:file => "/Applications/#{appname}/Contents/Info.plist")
                results=CFPropertyList.native_types(plist.value)
                return results["CFBundleShortVersionString"]
            end
        else
            return "Error: Appliction can't be found"
        end
    end

    #list the aspps in a users dock
    def self.dock_apps(user = CURRENTUSER)

        plist = CFPropertyList::List.new(:file => "/Users/#{user}/Library/Preferences/com.apple.dock.plist")
        results=CFPropertyList.native_types(plist.value)
        apps=[]
        for key, value in results['persistent-apps']
            for key, value in key
                if value.class == Hash
                    for x, y in value
                        if x == "file-label"
                            apps.push(y)
                        end
                    end
                end
            end
        end
        return apps
    end

    #list the apps bundle ids in the users dock
    def self.dock_bundles(user = CURRENTUSER)
        plist = CFPropertyList::List.new(:file => "/Users/#{user}/Library/Preferences/com.apple.dock.plist")
        results=CFPropertyList.native_types(plist.value)
        apps=[]
        for key, value in results['persistent-apps']
            for key, value in key
                if value.class == Hash
                    for x, y in value
                        if x == "bundle-identifier"
                            apps.push(y)
                        end
                    end
                end
            end
        end
        return apps
    end

    #list the receipts for apps that were installed
    def self.receipts
        results=`pkgutil --pkgs`.lines
    end

    #list options
    def self.options
        return CookieDough.methods(false).sort
    end
end

# puts CookieDough.user_installed_apps