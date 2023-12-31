Rails.application.routes.draw do
  namespace 'api' do
    post '/users', to: 'users#create'
    post '/users/login', to: 'authentication#login'
    post '/articles/:slug/favorite', to: 'articles#favorite'
    delete '/articles/:slug/favorite', to: 'articles#unfavorite'
    resources :articles, only: %i[create]
    resources :articles, param: :slug, only: %i[edit update show destroy]
  end
end
