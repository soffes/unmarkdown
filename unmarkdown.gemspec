# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unmarkdown/version'

Gem::Specification.new do |spec|
  spec.name          = 'unmarkdown'
  spec.version       = Unmarkdown::VERSION
  spec.authors       = ['Sam Soffes']
  spec.email         = ['sam@soff.es']
  spec.summary       = 'Convert HTML to Markdown'
  spec.homepage      = 'https://github.com/soffes/unmarkdown'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_development_dependency 'bundler'

  # HTML parsing
  spec.add_dependency 'nokogiri'
end
