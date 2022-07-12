Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "articles#index"

  namespace :admin do
    resources :articles
    resources :categories
    resources :users
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

  # get 'password/reset', to: "password_resets#new"
  # post 'password/reset', to: "password_resets#create"
  # get 'password/reset/edit', to: "password_resets#edit"
  # patch 'password/reset/edit', to: "password_resets#update"

  get 'password/forgot', to: "passwords#new"
  post 'password/forgot', to: "passwords#create"
  get 'password/reset', to: "passwords#forgot"
  patch 'password/reset', to: "passwords#reset"

  get '/categories/:id', to: 'articles#category_posts', as: 'category_posts'
  #resources :categories

  resources :articles do
    resources :comments

    collection do
      get :search
    end
  
  end  

end
