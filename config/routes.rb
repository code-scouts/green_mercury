GreenMercury::Application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}
  root 'index#index'
end
