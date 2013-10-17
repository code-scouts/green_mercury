GreenMercury::Application.routes.draw do
  root 'index#index'

  resources :events

  post '/session', controller: :session, action: :acquire_session, as: :acquire_session
  post '/logout', controller: :session, action: :logout, as: :logout

  get '/profile/edit', controller: :profile, action: :edit, as: :edit_profile
  get '/profile/:uuid', controller: :profile, action: :show, as: :show_profile
end
