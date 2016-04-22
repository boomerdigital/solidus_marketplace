# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_marketplace'
  s.version     = '0.5'
  s.summary     = 'Solidus Marketplace Gem'
  s.description = 'Solidus Marketplace Gem'
  s.required_ruby_version = '>= 2.1'

   s.author    = 'Daniel Honig'
   s.email     = 'Daniel@boomer.digital'
   s.homepage  = 'http://boomer.digital'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "solidus", [">= 1.0.0", "<= 1.2.2"]

  s.add_development_dependency "rspec-rails", "~> 3.2"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sass-rails"
  s.add_development_dependency "coffee-rails"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "capybara"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "ffaker"
end
