NimbusWebapp::Application.routes.draw do

  constraints protocol: (Rails.env.production? ? 'https://' : 'http://') do
    get '/api/connection/:id', to: 'connections#show', defaults: {format: :json}
    get '/api/user', to: 'users#show', defaults: {format: :json}
    get '/api/user/connections', to: 'connections#index', defaults: {format: :json}
  end

  resources :connections, only: [:destroy, :edit, :update]
  get '/connections/authorize/:oauth', to: 'connections#authorize'

  resource :user, only: [:create, :new, :destroy, :edit, :update] do
    get 'delete'
    get 'verify'
    get 'resend_verification'
    resource :password, only: [:edit, :update]
    resource :email_address, only: [:edit, :update]
    resource :password_reset, only: [:create, :new, :edit, :update]
    resources :connections, only: [:create]
  end

  resource :session, only: [:create, :destroy, :new]

  root to: 'static_pages#home'
  get '/logout', to: 'sessions#destroy'
  get '/features', to: 'static_pages#features'
  get '/about', to: 'static_pages#about'
  get '/contribute', to: 'static_pages#contribute'
  get '/agreement', to: 'static_pages#agreement'

end
