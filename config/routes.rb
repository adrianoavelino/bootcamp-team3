Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :pomodoro_settings
  resources :pomodoros, only: [:create, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks
  resources :statistics, only: [:index]
end
