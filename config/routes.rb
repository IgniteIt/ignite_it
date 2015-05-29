Rails.application.routes.draw do
  root to: "home#index"
  get 'home' => 'home#index'
  resources :projects do
    resources :charges
    resources :followers
    resources :donations
    resources :blogs do
      resources :comments
    end
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => :registrations, :passwords => :passwords }

  # devise_scope :user do
  #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end
end
