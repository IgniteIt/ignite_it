Rails.application.routes.draw do
  root to: "projects#index"
  resources :projects
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # 
  # devise_scope :user do
  #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end
end
