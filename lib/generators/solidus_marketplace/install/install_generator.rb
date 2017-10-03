module SolidusMarketplace
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_marketplace\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/solidus_marketplace\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_marketplace\n", :before => /\*\//, :verbose => true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/solidus_marketplace\n", :before => /\*\//, :verbose => true
      end

      def include_seed_data
        seed_file = "db/seeds.rb"
        content = "SolidusMarketplace::Engine.load_seed if defined?(SolidusMarketplace)"
        append_file(seed_file, content) unless File.readlines(seed_file).last == content
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=solidus_marketplace'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ENV['AUTO_RUN_MIGRATIONS'] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
