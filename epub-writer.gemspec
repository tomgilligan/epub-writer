require File.expand_path('../lib/epub-writer/version', __FILE__)
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name                       = 'epub-writer'
  gem.date                       = '2016-08-27'
  gem.summary                    = 'EPUB Writer'
  gem.description                = 'Easily write structurally simple EPUBs'
  gem.authors                    = ['Tom Gilligan']
  gem.email                      = 'tom.gilligan88@icloud.com'
  gem.homepage                   = 'https://github.com/tomgilligan/epub-writer'
  gem.license                    = 'MIT'

  gem.files                      = `git ls-files`.split("\n")
  gem.test_files                 = `git ls-files -- test/*`.split("\n")
  gem.require_paths              = ["lib"]
  gem.version                    = EPUBWriter::VERSION

  gem.required_ruby_version      = '>= 2.3.1'
  gem.add_runtime_dependency       'nokogiri', '>= 1.6.8', '< 2.0'
  gem.add_runtime_dependency       'rubyzip', '>= 1.2.0', '< 2.0'
  gem.add_development_dependency   'minitest'
end
