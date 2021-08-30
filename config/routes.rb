Rails.application.routes.draw do
  get 'access_token/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'login', to: 'access_tokens#create'
  resources :articles, only: [:index, :show]
end
