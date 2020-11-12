Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static_pages#home"
  devise_for :users
  resource :subscription
  resource :resume_subscription, only: [:update]
  resources :html_ducuments, only: [:show]
  resources :websites do
    resources :webpages, only: [:show, :create] do
      resources :html_ducuments, only: [:show]
    end
  end
end
