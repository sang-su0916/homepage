Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Public routes with optional locale
  scope "(:locale)", locale: /ko|en/ do
    root "public/home#index"

    scope module: :public do
      resources :portfolios, only: [ :index, :show ]
      resources :contacts, only: [ :new, :create ]
      get "contact/success", to: "contacts#success", as: :contact_success
      resources :contents, only: [ :index, :show ]
      resources :blog, only: [ :index, :show ], controller: "blog"
    end
  end

  # Admin routes (no locale - internal use)
  namespace :admin do
    root "portfolios#index"

    get "login", to: "sessions#new", as: :login
    resource :session, only: [ :create, :destroy ]

    resources :portfolios
    resources :contacts, only: [ :index, :show, :update, :destroy ]
    resources :blog, controller: "blog"
  end
end
