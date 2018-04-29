Rails.application.routes.draw do
  post   '/FrontController',  to: 'front_controller#post'
end
