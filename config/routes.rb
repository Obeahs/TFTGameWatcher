Rails.application.routes.draw do
  get 'about', to: 'pages#about'

  resources :users, only: [:index]
  root 'users#index'
  
end
