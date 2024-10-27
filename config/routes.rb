Rails.application.routes.draw do
  get 'about', to: 'pages#about'

  root 'home#index'
  resources :users, only: [:index, :show]
end
