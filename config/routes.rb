Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :websites
  resources :html_ducuments, only: [:show]
end
