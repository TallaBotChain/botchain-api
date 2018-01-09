Rails.application.routes.draw do

  get "/access_token" => "auth#access_token", as: :access_token

  namespace :v1 do

    resources :developer_records, only: [:create]
    resource :developer_records, only: [:show, :update]

    resources :bots, only: [:create, :index]
    resource :bots, only: [:show, :update] do
      put :transfer
      patch :transfer
    end

    resources :developers, only: [:create]
    resource :developers, only: [:destroy]
  end
end
