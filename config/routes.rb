Ptast::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  #resources :logins
  #root :to => "logins#index"

  resources :user_sessions
  root :to => "user_sessions#new"
  resources :semesters do
    resources :courses
    resources :teachers
    resources :ptainstructors
    resources :students do
      resources :enrollments
    end
    collection do
    end
  end
  match '/semesters/:semester_id/import' => 'semesters#import', :as=>'semester_import', :via=>[:put]
  match '/semesters/:semester_id/date' => 'semesters#delete_date', :as=>'semester_delete_date', :via=>[:put]
  match '/semesters/:semester_id/calculate_meetings' => 'courses#calculate_meetings', :as=>'calculate_meetings'
  #match '/calculate_total_fees' => 'courses#calculate_total_fees', :as=>'calculate_total_fees'
  match '/coursefee/:id' => 'courses#coursefee', :as => 'coursefee'
  match '/user_session/destroy' => 'user_sessions#destroy', :as => 'user_session_destroy'
  #resources :teachers
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
