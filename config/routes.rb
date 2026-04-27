Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resource :session, only: %i[create]

    resources :users, only: %i[show create] do
      get :me, on: :collection
      scope module: :users do
        resources :posts, only: %i[show index]
        resources :followers, only: :index
        resources :followings, only: :index
        resource :follow, only: %i[create destroy]
      end
    end

    resources :posts, only: %i[create destroy]

    resource :timeline, only: :show
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
