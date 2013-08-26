GreenMercury::Application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}
  root 'index#index'
  get '/events', controller: :events, action: :index
  post '/events/rsvp/:id', controller: :events, action: :rsvp, as: :event_rsvp
  get '/events/get_token', controller: :events
end
