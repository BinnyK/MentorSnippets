Rails.application.routes.draw do
  resources :tweets
  resources :mentors
  root 'mentors#mentor_signup'

  get '/be-a-mentor', to: 'mentors#mentor_signup'


  get 'update_mentor', to: 'mentors#update_mentor'
  get 'retrieve_tweets', to: 'tweets#retrieve_tweets'
  
  resources :questions
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
