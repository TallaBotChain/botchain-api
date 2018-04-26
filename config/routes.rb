Rails.application.routes.draw do

  root "application#welcome"
  
  namespace :v1 do 
    get "/access_token" => "auth#access_token", as: :access_token

    resources :developer_records, only: [:create]
    resource :developer_records, only: [:show, :update] do 
      get :eth_transaction
    end 

    resources :bots, only: [:create] do 
      collection do 
        get :search
        get :identity_verification
      end
    end
    resource :bots, only: [:show, :update]

    resources :developers, only: [:create]
    resource :developers, only: [:destroy]
  end
end
