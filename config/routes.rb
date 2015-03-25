Myfitlist::Application.routes.draw do
  root to: 'pages#front'

  get '/sign_up',  to: 'users#new'
  get '/sign_in',  to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :plans, only: [:new, :create, :show, :update] do
    resources :items, only: [:new, :create, :update, :destroy]
  end

  resources :users, only: [:create]
end
