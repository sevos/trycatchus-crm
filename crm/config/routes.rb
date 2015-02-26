Rails.application.routes.draw do
  resources :contacts do
    resources :notes
  end
end
