Rails.application.routes.draw do
  root "users#new"

  resources :users, only: %i[ new create ]

  resources :rooms do
    resources :messages, module: :rooms

    member do
      post :generate_hash
      delete :destroy_hash
      get :check
      post :join
      get :confirm
      delete :leave
    end
  end

end
