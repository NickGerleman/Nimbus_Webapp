NimbusWebapp::Application.routes.draw do
  constraints subsomain: 'api', protocol: 'https' do
    get '/test', to: 'static_pages#home'
  end
  resources :connections, only: [:new, :destroy]
  resources :users, only: [:create, :show, :new, :destroy]
  resources :sessions, only: [:create, :destroy]
  root to: 'static_pages#home'
  get '/features', to: 'static_pages#features'
  get '/about', to: 'static_pages#about'
  get '/contribute', to: 'static_pages#contribute'
  get '/login', to: 'users#login'
  get '/logout', to: 'sessions#destroy'
  get '/user', to: 'users#show'
  get '/user/delete', to: 'users#delete'
  get '/settings', to: 'users#settings'
  get '/verify', to: 'users#verify'
  get '/connections/authorize/:oauth', to: 'connections#authorize'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
