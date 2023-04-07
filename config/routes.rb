Rails.application.routes.draw do
  root 'expenses#index'
  resources :expenses
  get 'max', to: "expenses#max"

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
