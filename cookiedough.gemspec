# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cookiedough/version'

Gem::Specification.new do |spec|
  spec.name          = "cookiedough"
  spec.version       = CookieDough::VERSION
  spec.authors       = ["Nic Scott"]
  spec.email         = ["nls.inbox@gmail.com"]

  spec.summary       = %q{A Ruby gem for macOS machines to report on Applications}
  spec.homepage      = "https://github.com/nlscott/cookiedough"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.2.33"
  spec.add_development_dependency "rake", ">= 11.2.2"
  spec.add_development_dependency "minitest", "5.18.1"
  spec.add_development_dependency "CFPropertyList", ">= 3.0.6"

end
