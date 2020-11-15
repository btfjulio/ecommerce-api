Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    namespace :v1 do
      get "/home", to: "home#index"
      resources :categories, only: %i(index show create update destroy)
      resources :system_requirements, only: %i(index show create update destroy)
      resources :coupons, only: %i(index show create update destroy)
      resources :users, only: %i(index show create update destroy)

    end
  end 

  namespace :storefront do
    namespace :v1 do
      
    end
  end 
end
