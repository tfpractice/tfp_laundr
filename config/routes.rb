Rails.application.routes.draw do


  resources :loads
  concern :machine do
    member do
      patch :claim, :fill, :unclaim, :start, :remove_clothes
      patch ':insert_coins/:count', action: :insert_coins, as: 'insert_coins'
    end
  end
  resources :dryers, concerns: :machine 
  resources :washers, concerns: :machine 
  # resources :washers do
  # member do
  #   patch :claim, :fill, :unclaim, :insert_coins, :start, :remove_clothes
  # end
  # end
  resources :s_washers, controller: 'washers', type: 'SWasher'#, concerns: :machine
  resources :m_washers, controller: 'washers', type: 'MWasher'#, concerns: :machine
  resources :l_washers, controller: 'washers', type: 'LWasher'#, concerns: :machine
  resources :xl_washers, controller: 'washers', type: 'XLWasher'#, concerns: :machine

  devise_for :users, controllers: { registrations: 'users/registrations'  }  # get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'washers#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
