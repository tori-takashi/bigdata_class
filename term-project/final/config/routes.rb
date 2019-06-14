Rails.application.routes.draw do
  root to: "article#index"

  resources :article, only: [:index, :show, :create, :new] do
  end

  post "article/upload", to: "article#upload"

  resources :user, only: [:index, :create, :new] do
  end

  get "user/login", to: "user#login"
  get "user/logout", to: "user#logout"
  post "user/auth", to: "user#auth"

end
