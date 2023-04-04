Rails.application.routes.draw do
  root 'expenses#index'
  resources :expenses
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
