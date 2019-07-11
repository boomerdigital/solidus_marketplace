# frozen_string_literal: true

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'solidus_marketplace/version'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'solidus_marketplace'
  s.version = SolidusMarketplace::VERSION
  s.summary = 'Solidus Marketplace Extension'
  s.description = 'Adds marketplace functionality to Solidus stores.'
  s.required_ruby_version = '>= 2.0'

  s.author = 'Jonathan Tapia'
  s.email = 'jonathan.tapia@magmalabs.io'
  s.homepage = 'https://github.com/jtapia/solidus_marketplace'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus_core', ['>= 2.2', '< 3']
  s.add_dependency 'solidus_support'
  s.add_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
