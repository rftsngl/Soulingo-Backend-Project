Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # ActionCable WebSocket endpoint
  mount ActionCable.server => '/cable'

  # API v1 routes
  namespace :v1 do
    # Authentication endpoints
    post 'auth/register', to: 'auth#register'
    post 'auth/login', to: 'auth#login'
    get 'auth/me', to: 'auth#me'

    # Course endpoints
    resources :courses, only: [:index, :show, :create, :update, :destroy] do
      member do
        post 'enroll', to: 'enrollments#enroll'
        get 'students', to: 'enrollments#students'
      end
      resources :lessons, only: [:index, :create], controller: 'lessons'
    end

    # Lesson endpoints
    resources :lessons, only: [:show, :update, :destroy] do
      resources :session_analyses, only: [:create], controller: 'session_analyses'
      get 'session_analyses', to: 'session_analyses#lesson_analyses', on: :member
    end

    # User endpoints
    resources :users, only: [] do
      member do
        get 'courses', to: 'enrollments#user_courses'
        get 'session_analyses', to: 'session_analyses#user_analyses'
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
