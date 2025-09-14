Rails.application.routes.draw do
  root to: "home#index"

  # Simple health endpoint
  get "/health", to: proc { [200, {"Content-Type" => "application/json"}, [{status: "healthy"}.to_json]] }

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      post "auth/logout", to: "auth#logout"
      get  "profile", to: "auth#profile"
      put  "profile", to: "auth#update_profile"
      post "change-password", to: "auth#change_password"

      resources :artists
      resources :episodes
      scope :social do
        resources :posts, controller: "social_posts", only: [:index, :create] do
          post :schedule, on: :member
        end
      end
    end
  end

  # HTML UI
  get "/dashboard", to: "dashboard#index", as: :dashboard
  resources :artists
  resources :episodes
end
