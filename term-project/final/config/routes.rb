Rails.application.routes.draw do
  root to: "article#index"

  resources :article, only: [:index, :show, :create, :new] do
  end

  post "article/upload", to: "article#upload"

end
