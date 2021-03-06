Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  concern :state_scopeable do
    collection do
      get :draft
      get :submitted
      get :approved
      get :fulfilled
      get :archived
      # get :canceled
    end
  end

  resources :sites, only: [:index] do
    resources :orders, only: [:index], concerns: :state_scopeable
  end

  resources :orders, concerns: :state_scopeable do
    member do
      put :review
      put :submit
      put :approve
      put :fulfill
      put :archive
      put :cancel
    end

    resources :line_items
    resources :comments, only: [:create]
    resources :approvals, only: [:create]
  end

  resources :products
  resources :product_groups
  resources :imports, only: [:new, :create]

  namespace :admin do
    resources :sites
    resources :users
    resources :roles
  end

  authenticated :user, lambda {|u| u.staff?} do
    root to: 'orders#draft', as: :staff_root
  end

  authenticated :user, lambda {|u| u.approver?} do
    root to: 'orders#submitted', as: :approver_root
  end

  authenticated :user, lambda {|u| u.warehouse?} do
    root to: 'orders#approved', as: :warehouse_root
  end

  authenticated :user, lambda {|u| u.finance?} do
    root to: 'orders#fulfilled', as: :finance_root
  end

  # root to: 'orders#draft',      as: :staff_root,      constraints: RoleConstraint.new(:staff)
  # root to: 'orders#approved',   as: :warehouse_root,  constraints: RoleConstraint.new(:warehouse)
  # root to: 'orders#fulfilled',  as: :finance_root,    constraints: RoleConstraint.new(:finance)
  # root to: 'orders#submitted',  as: :approval_root,   constraints: RoleConstraint.new(:principal, :quantity)

  root to: 'orders#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
