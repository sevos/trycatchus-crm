Rails.application.routes.draw do
  resource :user
  resources :contacts do
    resources :notes
  end
end
