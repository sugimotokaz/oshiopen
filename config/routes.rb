Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

  # 開発環境へのメールテストに関する記述
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "static_pages#top"
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :profiles, only: %i[show edit update] do
    get :my_articles, on: :member  # プロフィールに対するユーザーごとの記事一覧
    resources :oshi_details, only: %i[new create edit update destroy], shallow: true
    get :favorite_articles, on: :member # プロフィールに対するユーザーごとのお気に入り記事一覧
    get :follow_users, on: :member # プロフィールに対するユーザーごとのお気に入りユーザー一覧
  end
  resources :articles, only: %i[index new create show edit update destroy] do
    resources :comments, only: %i[create edit update destroy], shallow: true
  end
  resources :favorites, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :password_resets, only: %i[new create edit update]
  # Google認証に関するルーティング
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" 
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  resources :notifications, only: %i[index destroy] do
    patch :mark_as_read, on: :member
  end
end
