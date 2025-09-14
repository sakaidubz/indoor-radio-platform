Rails.application.routes.draw do
  root to: "home#index"

  # Simple health endpoint
  get "/health", to: proc { [200, {"Content-Type" => "application/json"}, [{status: "healthy"}.to_json]] }
end

