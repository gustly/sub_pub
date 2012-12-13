# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sub_pub/version'

Gem::Specification.new do |gem|
  gem.name          = "sub_pub"
  gem.version       = SubPub::VERSION
  gem.authors       = ["zephyr-dev@googlegroups.com"]
  gem.email         = ["zephyr-dev@googlegroups.com"]
  gem.description   = %q{In process publish/subscribe for Ruby}
  gem.summary       = %q{SubPub is a thin wrapper around ActiveSupport::Notifications, which provides an implementation of the Publish/Subscribe pattern.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
