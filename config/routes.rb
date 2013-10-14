GreenMercury::Application.routes.draw do
  resources :mentor_petitions
  resources :member_petitions
  root 'index#index'
  get '/events', controller: :events, action: :index
  post '/events/rsvp/:id', controller: :events, action: :rsvp, as: :event_rsvp
  get '/events/get_token', controller: :events

  post '/session', controller: :session, action: :acquire_session, as: :acquire_session
  post '/logout', controller: :session, action: :logout, as: :logout
end
