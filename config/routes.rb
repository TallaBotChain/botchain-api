Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :v1 do 
    resources :organizations, only: [:create]
    resource :organization, only: [:show, :update] 
  end
end
