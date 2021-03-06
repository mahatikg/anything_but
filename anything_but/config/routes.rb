Rails.application.routes.draw do
  root "welcome#index"

  resources :users

  resources :recommendations, only: [:create, :show]

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'

  get '/dashboard', to: 'users#show'


  get '/new-recommendation', to: 'recommendations#show'

  get '/activities', to: 'activities#index', as: 'activities'

  post "/user-liked-recommendation", to: 'recommendations#add_user_liked_activity'

end
