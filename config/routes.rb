Shows::Application.routes.draw do

  resources :users do
    member do
      get :stats
    end
  end

  resources :shows do
    member do
      post :join
      put :kick
      put :archive
      put :unarchive
    end

    collection do
      get :archived
      get :feed
    end
  end

  root :to => 'shows#index'

  match 'signup' => 'users#new', :as => 'signup'
  match 'logout' => 'sessions#destroy', :as => 'logout'
  match 'login' => 'sessions#new', :as => 'login'

  match 'help' => 'application#textile_help', :as => 'textile_help'

  match 'stats' => 'statistics#stats', :as => 'stats'

  resources :sessions
end

