require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
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
  get "pricing", to: "static_pages#pricing", as: "pricing"
  get "faqs", to: "static_pages#faqs", as: "faqs"
  get "terms-of-use", to: "static_pages#terms_of_use", as: "terms"
  get "privacy-policy", to: "static_pages#privacy_policy", as: "privacy"
end
