Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "articles#index"

  namespace :admin do
    resources :articles do
      get :search, on: :collection
    end  
    
    resources :categories
    
    resources :users do
      get :search, on: :collection
    end  
  end  
  
  get "profile", to: "users#show"
  get "users/:id/posts", to: "users#posts", as: "user_posts"
  resources :users

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "my_posts", to: "articles#my_posts"

  get "password", to: "passwords#edit", as: "edit_password"
  patch "password", to: "passwords#update"

  get 'password/forgot', to: "passwords#new"
  post 'password/forgot', to: "passwords#create"
  get 'password/reset', to: "passwords#forgot"
  patch 'password/reset', to: "passwords#reset"

  get '/categories/:id', to: 'articles#category_posts', as: 'category_posts'

  resources :articles do
    resources :comments
    
    get :search, on: :collection
  end  

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

end
