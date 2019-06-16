Rails.application.routes.draw do
  root to: "article#index"

  #articles
  resources :article, only: [:index, :show, :create, :new] do
  end

  post "article/upload", to: "article#upload"

  #users
  resources :user, only: [:index, :create, :new] do
  end

  get  "user/login", to: "user#login"
  get  "user/logout", to: "user#logout"
  post "user/auth", to: "user#auth"

  get  "user/calc_current_point", to: "user#calc_current_point"

  #transactions
  post "transaction/purchase_article", to: "transaction#purchase_article"
  get  "transaction/add_point", to: "transaction#add_point"
  post "transaction/purchase_point", to: "transaction#purchase_point"
  get  "transaction/purchase_history", to: "transaction#purchase_history"

end
