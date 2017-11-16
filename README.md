# Solidus Marketplace

# NOTE: This gem is currently a work-in-progress. 
Contributors are welcome to help us get this gem to a viable MVP.
We suggest installing [ZenHub](http://zenhub.com) in order to view/manage open issues. 
This will give you a new tab in Github called "Boards", which provides a Kanban-style view of the project's issues.

# Overview

This is marketplace implementation for solidus.

Basic functionality:
* Links products to one or more suppliers
* Once an order is placed: 
  * A shipment is created for the product's supplier
  * The shipment is then sent to the store owner for fulfillment and to the supplier for visibility (via Email by default). 
  * The store owner fulfills orders. The supplier can view their shipments (read-only for now).

Installation
------------
Here's how to install solidus_marketplace into your existing spree site AFTER you've installed Spree:

Add the following to your Gemfile:

    gem 'solidus_marketplace'

Make your bundle happy:

    bundle install

Now run the generator:

    rails g solidus_marketplace:install

(Optional) Run the generator for solidus_gateway to enable the use of Stripe or other payment providers
included with that extension:

    rails g solidus_gateway:install

Then migrate your database if you did not run during installation generator:

    bundle exec rake db:migrate

And reboot your server:

    rails s

You should be up and running now!

Sample Data
-----------

If you'd like to generate sample data, use the included rake tasks:

```shell
rake db:seed                         # Loads seed data into the store
rake spree_sample:load               # Loads sample data into the store
rake spree_sample:suppliers          # Create sample suppliers and randomly link to products
rake spree_sample:marketplace_orders # Create sample marketplace orders
```

This will include a new role (supplier_admin) and 2 new users in addition to the default 'admin@example.com' user provided by solidus.

Those users have the following email/password/roles

* marketmaker@example.com / test123 / admin
* supplier_admin@example.com / test123 / supplier_admin

Demo
----

You can easily use the spec/dummy app as a demo of solidus_marketplace. Just `cd` to where you develop and run:

```shell
git clone git://github.com/boomerdigital/solidus_marketplace.git
cd solidus_marketplace
bundle install
bundle exec rake test_app
cd spec/dummy
rake db:migrate db:seed spree_sample:load spree_sample:suppliers spree_sample:marketplace_orders
rails s
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
brew install geckodriver

bundle
bundle exec rake test_app
bundle exec rspec spec
```

Todo
----

* See open issues here: [open issues](https://github.com/boomerdigital/solidus_marketplace/issues)

Contributing
------------

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs](https://github.com/boomerdigital/solidus_marketplace/issues)
* by suggesting new features
* by [translating to a new language](https://github.com/boomerdigital/solidus_marketplace/tree/master/config/locales)
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues](https://github.com/boomerdigital/solidus_marketplace/issues)
* by reviewing patches

Donating
--------

Copyright (c) 2016-2017 Boomer Digital, released under the [New BSD License](https://github.com/boomerdigital/solidus_marketplace/tree/master/LICENSE).
