Rails.application.routes.draw do
  root to: "projects#index"
  resources :projects do
    resources :charges
    resources :followers
    resources :donations
    resources :blogs do
      resources :comments
    end
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get "/projects_controller/refresh_donate" => "projects#refresh_donate"
end
