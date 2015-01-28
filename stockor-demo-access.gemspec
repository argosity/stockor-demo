# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stockor-demo-access/version'

Gem::Specification.new do |spec|

  spec.name          = "stockor-demo-access"
  spec.version       = StockorDemoAccess::VERSION
  spec.authors       = ["Nathan Stitt"]
  spec.email         = ["nathan@argosity.com"]

  spec.summary       = %q{Grant Demo access to the Stockor ERP system}
  spec.description   = %q{Grant Demo access to Stockor, a complete ERP system that includes billing, inventory, and customer management}

  spec.homepage      = "http://stockor.org/"
  spec.license       = "GPL-3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'lanes'

end
