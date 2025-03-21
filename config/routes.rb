Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # API routes
  namespace :api do
    devise_scope :user do
      post 'login', to: 'users/sessions#create'
      delete 'logout', to: 'users/sessions#destroy'
    end
    
    resources :contacts do
      resources :reminders, only: [:create, :update, :destroy]
      resources :interactions, only: [:create, :update, :destroy]
    end
    resources :reminders
    resources :interactions, only: [:index, :show]
  end

  # Web routes
  resources :contacts do
    resources :reminders, only: [:create, :update, :destroy]
    resources :interactions, only: [:create, :update, :destroy]
  end
  resources :interactions, only: [:index, :show]
  resources :reminders, only: [:index, :show]
  resources :tags
  resources :todos

  root "contacts#index"

  # Add or remove tags from contacts
  post 'contacts/:contact_id/tags/:tag_id', to: 'contact_tags#create', as: 'add_tag_to_contact'
  delete 'contacts/:contact_id/tags/:tag_id', to: 'contact_tags#destroy', as: 'remove_tag_from_contact'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end

