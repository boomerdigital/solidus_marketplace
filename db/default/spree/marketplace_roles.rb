# frozen_string_literal: true

# create supplier_admin role, new supplier and supplier_admin
supplier_admin_role = Spree::Role.where(name: 'supplier_admin').first_or_create
supplier_admin = Spree::User.create(email: 'supplier_admin@example.com',
                                    password: 'test123',
                                    password_confirmation: 'test123')
supplier_admin.spree_roles << supplier_admin_role

supplier_staff_role = Spree::Role.where(name: 'supplier_staff').first_or_create
supplier_staff = Spree::User.create(email: 'supplier_staff@example.com',
                                    password: 'test123',
                                    password_confirmation: 'test123')
supplier_staff.spree_roles << supplier_staff_role

new_supplier = Spree::Supplier.create(name: "Kevin's Guitars")
new_supplier.admins = [supplier_admin, supplier_staff]

# create marketmaker user
admin_role = Spree::Role.find_by(name: 'admin')
marketmaker = Spree::User.create(email: 'marketmaker@example.com',
                                 password: 'test123',
                                 password_confirmation: 'test123')
marketmaker.spree_roles << admin_role

