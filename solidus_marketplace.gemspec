 # encoding: UTF-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'solidus_marketplace/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_marketplace'
  s.version     = SolidusMarketplace::VERSION
  s.summary     = 'Solidus Marketplace Extension'
  s.description = 'Adds marketplace functionality to Solidus stores.'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Boomer Digital'
  s.email     = ''
  s.homepage  = 'https://github.com/boomerdigital/solidus_marketplace'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'durable_decorator', '~> 0.2.0'
  s.add_dependency 'solidus_api'
  s.add_dependency 'solidus_backend'
  s.add_dependency 'solidus_core'
  s.add_dependency 'solidus_gateway'

  s.add_development_dependency 'capybara',           '~> 2.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails', '~> 5.0.0.beta1'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'solidus_sample'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'log_buddy'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'pry'
end
