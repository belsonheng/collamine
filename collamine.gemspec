# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collamine/version'

Gem::Specification.new do |spec|
  spec.name          = "collamine"
  spec.version       = Collamine::VERSION
  spec.authors       = ["Belson Heng"]
  spec.email         = ["belsonheng@gmail.com"]
  spec.summary       = %q{Collamine lets you crawl a web site using SpiderCrawl library and share the results with the community via CollaMine servers.}
  spec.description   = %q{Collamine is a ruby gem for CollaMine client, which communicates with CollaMine servers to download content from their SmartCache if it exists.}
  spec.homepage      = "http://github.com/belsonheng/collamine/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "spidercrawl"
  spec.add_dependency "multipart-post"
  spec.add_dependency "domainatrix"
  spec.add_dependency "mongo"
  spec.add_dependency "bson_ext"
end
