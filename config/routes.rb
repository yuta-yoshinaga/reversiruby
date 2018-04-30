Rails.application.routes.draw do
	resources :sessions
	post   '/FrontController',  to: 'front_controller#post'
end
