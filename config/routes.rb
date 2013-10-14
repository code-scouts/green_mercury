GreenMercury::Application.routes.draw do
  root 'index#index'
  get '/events', controller: :events, action: :index
  post '/events/rsvp/:id', controller: :events, action: :rsvp, as: :event_rsvp
  get '/events/get_token', controller: :events

  post '/session', controller: :session, action: :acquire_session, as: :acquire_session
  post '/logout', controller: :session, action: :logout, as: :logout

  resources :concepts
  resources :concept_contents
end
