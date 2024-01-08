Rails.application.routes.draw do
  root to: "guest/pages#show", id: "welcome"

  namespace :admin do
    root to: redirect("admin/admin_users")

    get "login", to: "admin_sessions#new", as: :login
    get "logout", to: "admin_sessions#destroy", as: :logout
    get "forgot_password", to: "admin_sessions#forgot_password", as: :forgot_password
    post "forgot_password", to: "admin_sessions#forgot_password_submit", as: :forgot_password_submit
    get "reset_password/:reset_password_code", to: "admin_users#reset_password", as: :reset_password
    patch "reset_password/:reset_password_code", to: "admin_users#reset_password_submit", as: :reset_password_submit

    resources :admin_sessions, only: [:new, :create, :destroy]
    resources :admin_users do
      resource :user_notifications_pref, only: [:edit, :update]
    end

    resources :log_book_events, only: [:index]
    resources :front_users do
      get "articles", on: :member
      get "log_book_events", on: :member
    end
    resources :articles

    resources :articles_filters, only: [:new, :show] do
      get "create", on: :collection
    end
  end

  namespace :api do
    namespace :admin do
      resources :admin_users, only: [:index, :show, :create, :update, :destroy], param: :uuid
    end
  end

  namespace :front do
    root to: redirect("front/articles")

    get "login", to: "front_sessions#new", as: :login
    get "logout", to: "front_sessions#destroy", as: :logout
    get "forgot_password", to: "front_sessions#forgot_password", as: :forgot_password
    post "forgot_password", to: "front_sessions#forgot_password_submit", as: :forgot_password_submit
    get "reset_password/:reset_password_code", to: "front_users#reset_password", as: :reset_password
    patch "reset_password/:reset_password_code", to: "front_users#reset_password_submit", as: :reset_password_submit

    resources :front_sessions, only: [:new, :create, :destroy]

    resources :articles
    resources :front_users, only: [:show, :new, :create, :edit, :update, :destroy]
  end

  namespace :guest do
    root to: redirect("guest/articles")
    resources :pages, only: [:show]
    resources :articles, only: [:show, :index]
  end

  get '/auth/:provider/callback' => 'admin/admin_authorizations#create', constraints: ->(request) { request.env['omniauth.params']['from'] == 'admin' }
  get '/auth/:provider/callback' => 'front/front_authorizations#create', constraints: ->(request) { request.env['omniauth.params']['from'] == 'front' }
  get '/auth/failure' => 'share/authorizations#failure'
  get '/auth/:provider' => 'share/authorizations#blank'

  get 'health', to: "application#health"
end
