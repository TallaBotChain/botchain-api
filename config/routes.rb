Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :v1 do 
    resources :developer_records, only: [:create]
    resource :developer_records, only: [:show, :update] 

    resources :bots, only: [:create]
    resource :bot, only: [:show, :update] do 
      put :transfer
      patch :transfer
    end 
  end
end
