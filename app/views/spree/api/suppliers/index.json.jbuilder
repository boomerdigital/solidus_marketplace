json.suppliers(@suppliers) do |supplier|
  json.partial!("spree/api/suppliers/supplier", supplier: supplier)
end
json.partial! 'spree/api/shared/pagination', pagination: @suppliers
