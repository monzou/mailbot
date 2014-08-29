# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailbot/version'

Gem::Specification.new do |spec|
  spec.name          = "mailbot"
  spec.version       = Mailbot::VERSION
  spec.authors       = ["monzou"]
  spec.email         = ["1984tkr@gmail.com"]
  spec.summary       = "Learn with Mailbox"
  spec.homepage      = "https://github.com/monzou/mailbot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "slop"
  spec.add_dependency "coderay"
  spec.add_dependency "redcarpet"
  spec.add_dependency "mailgun-ruby"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
