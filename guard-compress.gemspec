# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/compress/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-compress"
  spec.version       = Guard::Compress::VERSION
  spec.authors       = ["myobie"]
  spec.email         = ["me@nathanherald.com"]
  spec.summary       = %q{Compress files with yui-compressor with guard}
  spec.description   = %q{Let's you compress files using a glob for Dir and even ignore some files.}
  spec.homepage      = "https://github.com/myobie/guard-compress"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "guard",               "~> 2.6.0"
  spec.add_dependency "yui-compressor",      "~> 0.12.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
