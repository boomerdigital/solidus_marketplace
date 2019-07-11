# Loads seed data out of default dir
default_path = File.join(File.dirname(__FILE__), 'default')

%w(
  marketplace_roles
).each do |seed|
  puts "Loading seed file: #{seed}"
  require_relative "default/spree/#{seed}"
end
