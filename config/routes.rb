# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  namespace :onboarding do
    root to: 'entries#show'
    resource :welcome, only: %i[show update]
    resource :account, only: %i[show update]
    resource :library, only: %i[show update]
    # resource :metadata, only: %i[show update] # disabled until provider settings ship
    resource :import, only: %i[show update]
    resource :completion, only: %i[show create]
  end
  resources :passwords, param: :token
  resource :session

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?
end
