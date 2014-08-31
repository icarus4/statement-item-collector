Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'parsers#index'

  # get 'parsers' => 'parsers#ifrs'
  get 'parsers/parse/' => 'parsers#parse'
  get 'parsers/ifrs(/:table_name(/:category(/:sub_category)))' => 'parsers#ifrs'
  get 'parsers/gaap(/:table_name(/:category(/:sub_category)))' => 'parsers#gaap'
  get 'parsers/parse_bank_stocks(/:start_year/:start_quarter/:end_year/:end_quarter)' => 'parsers#parse_bank_stocks'
  get 'parsers/parse_assurance_stocks(/:start_year/:start_quarter/:end_year/:end_quarter)' => 'parsers#parse_assurance_stocks'
  get 'parsers/parse_broker_stocks(/:start_year/:start_quarter/:end_year/:end_quarter)' => 'parsers#parse_broker_stocks'
  get 'parsers/parse_financial_stocks(/:start_year/:start_quarter/:end_year/:end_quarter)' => 'parsers#parse_financial_stocks'

  # post 'parsers/search/:search' => 'parsers#search'

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
