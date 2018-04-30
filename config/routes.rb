Rails.application.routes.draw do
#	protect_from_forgery with: :null_session
	post   '/FrontController',  to: 'front_controller#post'
end
