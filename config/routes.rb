Rails.application.routes.draw do
  root 'pages#index'
  get 'pages/index'
  get 'pages/search'

  resources :users

  get 'sessions/new'
  post 'sessions/create'
  post 'sessions/delete'
  post 'sessions/search'
  delete 'sessions/destroy'
end
