# create supplier_admin role, new supplier and supplier_admin user
supplier_admin_role = Spree::Role.where(name: "supplier_admin").first_or_create
new_supplier = Spree::Supplier.new(name: "Kevin's Guitars", email: "kevinsguitars@example.com")
supplier_admin = Spree::User.create(email: "supplier_admin@example.com",
                                    password: "test123",
                                    password_confirmation: "test123",
                                    supplier: new_supplier)
supplier_admin.spree_roles << supplier_admin_role

# create marketmaker user
admin_role = Spree::Role.find_by(name: "admin")
marketmaker = Spree::User.create(email: "marketmaker@example.com", password: "test123", password_confirmation: "test123")
marketmaker.spree_roles << admin_role

