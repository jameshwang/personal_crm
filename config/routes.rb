Rails.application.routes.draw do
  root 'contacts#index'

  resources :contacts do
    resources :interactions, only: [:index, :create, :destroy]
    resources :reminders, only: [:index, :create, :update, :destroy]
  end

  resources :tags, only: [:index, :create, :destroy]
  resources :todos, only: [:index]
  
  # Add or remove tags from contacts
  post 'contacts/:contact_id/tags/:tag_id', to: 'contact_tags#create', as: 'add_tag_to_contact'
  delete 'contacts/:contact_id/tags/:tag_id', to: 'contact_tags#destroy', as: 'remove_tag_from_contact'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
