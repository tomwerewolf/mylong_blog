Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # scope '(:locale)', locale: /en|vi/ do
  root 'articles#index'

  get 'profile', to: 'users#show'
  get 'users/:id/posts', to: 'users#posts', as: 'user_posts'
  resources :users

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'password', to: 'passwords#edit', as: 'edit_password'
  patch 'password', to: 'passwords#update'

  get 'password/forgot', to: 'passwords#new'
  post 'password/forgot', to: 'passwords#create'
  get 'password/reset', to: 'passwords#forgot'
  patch 'password/reset', to: 'passwords#reset'

  get '/categories/:id', to: 'articles#category_posts', as: 'category_posts'

  resources :categories

  resources :articles do
    resources :comments
    collection do
      get :search
      get :my_posts
    end
  end

  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :categories do
      get :search, on: :collection
    end
    resources :articles do
      resources :comments
      collection do
        get :search
      end
    end
    get 'profile', to: 'users#show'
    resources :users do
      get :search, on: :collection
      member do
        get :edit_roles, to: 'users#edit_roles'
        patch :edit_roles, to: 'users#update_roles'
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
