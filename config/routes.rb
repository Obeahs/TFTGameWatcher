Rails.application.routes.draw do
  get 'about', to: 'pages#about'

  root 'home#index'
  resources :users do
    member do
      get 'match_data/:id', to: 'users#match_data', as: 'match'
    end
end
