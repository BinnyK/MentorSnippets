Rails.application.routes.draw do
  resources :tweets
  resources :mentors
  root 'questions#index'

  get 'save_mentor', to: 'mentors#save_mentor'
  
  resources :questions
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
