NimbusWebapp::Application.routes.draw do

  constraints protocol: (Rails.env.production? ? 'https://' : 'http://'), subdomain: 'api' do
    resources :connections, only: [:show], defaults: {format: :json}
    resource :user, only: [:show] do
      resources :connections, only: [:index], defaults: {format: :json}
    end
  end

  resources :connections, only: [:destroy, :edit, :update]
  get '/connections/authorize/:oauth', to: 'connections#authorize'

  resource :user, only: [:create, :new, :destroy, :edit, :update] do
    get 'delete'
    get 'verify'
    resources :connections, only: [:create]
  end

  resource :session, only: [:create, :destroy, :new]

  root to: 'static_pages#home'
  get '/features', to: 'static_pages#features'
  get '/about', to: 'static_pages#about'
  get '/contribute', to: 'static_pages#contribute'

end
