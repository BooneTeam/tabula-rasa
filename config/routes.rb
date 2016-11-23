Rails.application.routes.draw do
  devise_for :basic_users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/apps/search', to: 'apps#search', as: 'app_search'
  resources :categories do
    resources :apps
  end

  resources :system_configs, only: [:create, :destroy, :update, :show]
  get 'system_configs/(:id)/deploy', to: 'system_configs#deploy', as: 'deploy_path'

  root to: 'apps#index'

end
