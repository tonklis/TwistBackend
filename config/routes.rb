TwistBack::Application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

  resources :templates

  resources :cards

  resources :turns

  resources :games do
		match 'start', :on => :collection
    match 'accept/:id' => 'games#accept', :on => :collection
    match 'ask/:id' => 'games#ask', :on => :collection
    match 'guess/:id' => 'games#guess', :on => :collection
    match 'last_turn/:id' => 'games#last_turn', :on => :collection
	end

  resources :boards do
    match 'close/:id' => 'boards#close', :on => :collection
    match 'abandon/:id' => 'boards#abandon', :on => :collection
  end

  resources :users do
		match 'registered', :on => :collection
	end

	match 'users/reset_badges/:id' => 'users#reset_badges'

	match 'send_notification_to_opponent' => 'notifications#send_notification_to_opponent'
	
	#Borrar, esta es para que sea backwards compatible
	match 'ios_send_notification_to_opponent' => 'notifications#send_notification_to_opponent'
	
	match 'ios_register' => 'notifications#ios_register'
	
	match 'android_register' => 'notifications#android_register'

	match 'login' => 'users#login', :as => :login

  match 'cards_by_type/:id' => 'templates#cards_by_type', :as => :get_type

  match 'games_by_user/:id' => 'users#games_by_user', :as => :games_by_user

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
