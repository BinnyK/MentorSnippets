Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :tweets
  resources :mentors
  root 'mentors#index'

  # get '/be-a-mentor', to: 'mentors#mentor_signup'


  get 'update_mentor', to: 'mentors#update_mentor'
  get 'retrieve_tweets', to: 'tweets#retrieve_tweets'
  
  resources :questions
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
