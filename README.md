# SolidusMarketplace

[![Build Status](https://travis-ci.org/jtapia/solidus_marketplace.svg?branch=master)](https://travis-ci.org/jtapia/solidus_marketplace)

This is marketplace implementation for solidus.

Basic functionality:
- Links products to one or more suppliers
- Once an order is placed:
  - A shipment is created for the product's supplier
  - The shipment is then sent to the store owner for fulfillment and to the supplier for visibility (via Email by default).
  - The store owner fulfills orders. The supplier can view their shipments (read-only for now).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solidus_marketplace', github: 'jtapia/solidus_marketplace'
```

Then run the following:

```console
$ bundle install
$ bundle exec rails g solidus_marketplace:install
```

(Optional) If you want to be able to see the reports, please add this line to your `Gemfile`:

```ruby
gem 'solidus_reports', github: 'solidus-contrib/solidus_reports'
```

(Optional) If you want to use Stripe or other payment providers, please add this line to your `Gemfile`:

```ruby
gem 'solidus_gateway'
```

and run

```ruby
rails g solidus_gateway:install
```

## Sample Data

If you'd like to generate sample data, use the included rake tasks:

```shell
rake db:seed                         # Loads seed data into the store
rake spree_sample:load               # Loads sample data into the store
rake spree_sample:suppliers          # Create sample suppliers and randomly link to products
rake spree_sample:marketplace_orders # Create sample marketplace orders
```

This will include a new role (supplier_admin) and 2 new users in addition to the default `admin@example.com` user provided by solidus.

Those users have the following email/password/roles

- marketmaker@example.com / test123 / admin
- supplier_admin@example.com / test123 / supplier_admin

## Testing

Run the following to automatically build a dummy app and run the tests:

```console
$ bundle exec rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/solidusio-contrib/solidus_abandoned_carts.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
