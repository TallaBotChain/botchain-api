Rails.application.routes.draw do
  
  namespace :v1 do 
    get "/access_token" => "auth#access_token", as: :access_token

    resources :developer_records, only: [:create]
    resource :developer_records, only: [:show, :update] 

    resources :bots, only: [:create]
    resource :bots, only: [:show, :update] do 
      put :transfer
      patch :transfer
    end

    resources :developers, only: [:create]
    resource :developers, only: [:destroy]
  end
end
