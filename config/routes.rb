Rails.application.routes.draw do
  root 'quotes#index'
  get 'quotes', to: 'quotes#index'
end