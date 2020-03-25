
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "private_address_check/version"

Gem::Specification.new do |spec|
  spec.name          = "private_address_check"
  spec.version       = PrivateAddressCheck::VERSION
  spec.authors       = ["John Downey"]
  spec.email         = ["jdowney@gmail.com"]

  spec.summary       = "Prevent Server Side Request Forgery attacks by checking the destination"
  spec.description   = "Checks if a IP or hostname would cause a request to a private network (RFC 1918)"
  spec.homepage      = "https://github.com/jtdowney/private_address_check"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{lib,test}/**/*.rb") + %w[CODE_OF_CONDUCT.md Gemfile LICENSE.txt README.md Rakefile]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubocop", "~> 0.80.1"
end
