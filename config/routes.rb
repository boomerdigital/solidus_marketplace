Spree::Core::Engine.routes.draw do

  namespace :admin do
    resource :marketplace_settings
    resources :shipments
    resources :suppliers
  end

  namespace :api do
    resources :suppliers, only: :index
  end

end

Spree::Core::Engine.routes.prepend do
  namespace :admin do
    resources :reports do
      collection do
        get   :earnings
        post  :earnings
      end
    end
  end
end
