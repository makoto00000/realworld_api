Rails.application.routes.draw do
  namespace 'api' do
    post '/users', to: 'users#create'
    put '/users', to: 'users#update'
    get '/user', to: 'users#current_user'
    post '/users/login', to: 'authentication#login'
    post '/articles/:slug/favorite', to: 'articles#favorite'
    delete '/articles/:slug/favorite', to: 'articles#unfavorite'
    get '/tags', to: 'tags#index'
    resources :articles, only: %i[index create]
    resources :articles, param: :slug, only: %i[edit update show destroy]
  end
end
