Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # TODO: Redirec to subscriptio#new on new user creation
  # TODO: Update Stripe URLs 
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  unauthenticated do
    root "static_pages#home"
  end
  authenticated :user do
    root "websites#index", as: :authenticated_root
  end
  resource :credit_card, only: [:update]
  resource :subscription
  resource :resume_subscription, only: [:update]
  resources :websites do
    resources :webpages, only: [:show, :edit, :create, :update, :destroy] do
      resources :screenshots, only: [:index, :show]
    end
    resources :zone_files, only: [:index, :show]
  end
end
