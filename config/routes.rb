require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :uni_user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'uni/showtimes#index'

  # namespace for product operators
  namespace :op do
    resources :shows
    resources :showtimes do
      member do
        post 'enroll', to: 'showtimes#enroll_on'
        delete 'enroll', to: 'showtimes#enroll_off'
      end
      resource :ballot, only: [ :create, :update, :destroy ], controller: 'campus_ballots'
      resource :lottery_event, only: [ :create, :update, :destroy ]
    end
    resources :universities
  end

  # namespace for university students
  namespace :uni do
    get 'profile/show'
    get 'showtimes/pk', to: 'showtimes#index', s_filter: 'pk'
    get 'showtimes/enroll', to: 'showtimes#index', s_filter: 'enr'

    devise_for :users, module: 'uni/users', path: 'account'
    resources :enrollments, only: [ :create, :destroy ]
    resources :showtimes, only: [ :index, :show ] do
      resource :vote, only: [ :create ], controller: 'campus_votes'
    end
  end

  namespace :api do
    namespace :v1 do
      resource :wechat, only: [ :show, :create ]
    end
  end

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
