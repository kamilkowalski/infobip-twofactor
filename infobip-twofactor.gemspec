# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infobip/twofactor/version'

Gem::Specification.new do |spec|
  spec.name          = "infobip-twofactor"
  spec.version       = Infobip::Twofactor::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors       = ["knx"]
  spec.email         = ["k.niksinski@visuality.pl"]
  spec.summary       = %q{Simple API wrapper gem for Infobip two factor authentication service}
  spec.description   = %q{Simple API wrapper gem for Infobip two factor authentication service}
  spec.homepage      = "http://visuality.pl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "fakeweb"

end
