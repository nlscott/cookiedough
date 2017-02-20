# CookieDough

A Ruby gem for macOS clients to report about items in the Applications folder.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cookiedough'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cookiedough

## Usage
To see a list of availible options for CookieDough, require 'CookieDough' in file then type:  
`puts CookieDough.options`


output should be similar to this:
***
	- all_app_versions
	- app_version
	- dock_apps
	- dock_bundles
	- list_apps
	- options
	- receipts
	- user_installed_apps

##  Examples:

To get all applications versions: `puts CookieDough.all_app_versions`

To get a single application versions: `puts CookieDough.app_version("pathtoapplication")`

To get what applications are in the dock of the current user: `puts CookieDough.dock_apps`

To specify a user add their username as an argument, this must be run as root: `puts CookieDough.dock_apps("username")`

To get what bundleid's are in the dock of the current user: `puts CookieDough.dock_bundles`

To specify a user add their username as an argument, this must be run as root: `puts CookieDough.dock_bundles("username")`

To get what's currently in Applications folder: `puts CookieDough.list_apps`

To get what's been installed with installer recipets: `puts CookieDough.receipts`

To get what's been installed by the user. This removes base apps that ship with macOS: `puts CookieDough.user_installed_apps`




## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

