Rails.application.routes.draw do
  root 'expenses#index'
  resources :expenses
  get 'max', to: 'expenses#max'
  get 'year_to_date', to: 'expenses#ytd'
  get 'six_months', to: 'expenses#six_months'
  get 'twelve_months', to: 'expenses#twelve_months'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
