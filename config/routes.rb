Spree::Core::Engine.routes.draw do

  namespace :admin do
    resource :drop_ship_settings
    resources :shipments
    resources :suppliers
  end

  namespace :api do
    resources :suppliers, only: :index
  end

end
