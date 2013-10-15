GreenMercury::Application.routes.draw do
  resources :mentor_applications
  resources :member_applications
  root 'index#index'
  get '/events', controller: :events, action: :index
  post '/events/rsvp/:id', controller: :events, action: :rsvp, as: :event_rsvp
  get '/events/get_token', controller: :events
  get '/new_applications/show', controller: :new_applications, action: :show, as: :new_application

  post '/session', controller: :session, action: :acquire_session, as: :acquire_session
  post '/logout', controller: :session, action: :logout, as: :logout
end
