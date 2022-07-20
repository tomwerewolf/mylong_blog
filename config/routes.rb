Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # scope '(:locale)', locale: /en|vi/ do
  root 'articles#index'

  get 'profile', to: 'users#show'
  resources :users do
    member do
      get :posts
    end
  end

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
  get 'my_posts', to: 'articles#my_posts'

  resources :categories

  resources :search_articles, only: [:index]

  resources :articles do
    resources :comments, only: [:create, :destroy]
    collection do
      delete :destroy_selected
    end
  end

  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :search_categories, only: [:index]
    resources :categories

    resources :search_articles, only: [:index]
    resources :articles do
      resources :comments
      collection do
        delete :destroy_selected
      end
    end

    resources :search_users, only: [:index]
    resources :users do
      member do
        get :edit_roles, to: 'users#edit_roles'
        patch :edit_roles, to: 'users#update_roles'
      end
    end  
  end

  namespace 'api' do
    namespace 'v1' do
      get 'profile', to: 'users#show'
      resources :search_users, only: [:index]
      resources :users do
        member do
          get :posts
        end
      end
    
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
      get 'my_posts', to: 'articles#my_posts'
    
      resources :search_categories, only: [:index]
      resources :categories
    
      resources :search_articles, only: [:index]
      resources :articles do
        resources :comments, only: [:create, :destroy]
        collection do
          delete :destroy_selected
        end
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # if Rails.env.development?
  #   mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  # end
  # post "/graphql", to: "graphql#execute"
end
