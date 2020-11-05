Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  resources :html_ducuments, only: [:show]
  resources :websites do
    resources :webpages, only: [:show, :create] do
      resources :html_ducuments, only: [:show]
    end
  end
end
