GreenMercury::Application.routes.draw do
  root 'index#index'

  resources :events
  resources :event_organizers, only: [:create, :destroy]

  post '/session', controller: :session, action: :acquire_session, as: :acquire_session
  post '/logout', controller: :session, action: :logout, as: :logout

  resources :concepts, except: [:destroy, :edit, :update]
  resources :concept_descriptions, only: [:new, :create, :destroy]
  get '/profile/edit', controller: :profile, action: :edit, as: :edit_profile
  get '/profile/:uuid', controller: :profile, action: :show, as: :show_profile
end
