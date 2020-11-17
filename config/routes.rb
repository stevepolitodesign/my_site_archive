Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "static_pages#home"
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resource :credit_card, only: [:update]
  resource :subscription
  resource :resume_subscription, only: [:update]
  resources :websites do
    resources :webpages, only: [:show, :edit, :create, :update, :destroy] do
      resources :html_documents, only: [:show]
    end
  end
end
