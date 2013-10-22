GreenMercury::Application.routes.draw do
  root 'index#index'
  get '/events', controller: :events, action: :index
  post '/events/rsvp/:id', controller: :events, action: :rsvp, as: :event_rsvp
  get '/events/get_token', controller: :events

  post '/session', controller: :session, action: :acquire_session, as: :acquire_session
  post '/logout', controller: :session, action: :logout, as: :logout

  resources :concepts, except: [:destroy, :edit, :update]
  resources :concept_descriptions, only: [:new, :create, :destroy]
  resources :requests
  get '/profile/edit', controller: :profile, action: :edit, as: :edit_profile
  get '/profile/:uuid', controller: :profile, action: :show, as: :show_profile
end
