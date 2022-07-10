Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "articles#index"
  
  get "profile", to: "users#show"

  resources :users

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "my_posts", to: "articles#my_posts"

  get "password", to: "passwords#edit", as: "edit_password"
  patch "password", to: "passwords#update"

  get '/categories/:name', to: 'articles#category_posts', as: 'category_posts'
  resources :categories

  resources :articles

end
