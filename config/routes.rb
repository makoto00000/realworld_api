Rails.application.routes.draw do
  namespace 'api' do
    post '/users', to: 'users#create'
    post '/users/login', to: 'authentication#login'
  end
end
