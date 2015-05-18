Rails.application.routes.draw do
  root to: "projects#index"
  resources :projects
  devise_for :users
end
