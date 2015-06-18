Rails.application.routes.draw do

  filter :locale, exclude: /^(\/admins|\/tinymce_assets)/

  post 'admin_session/create'
  delete 'admin_session/destroy'

  scope module: :admin do
    post '/tinymce_assets' => 'tinymce_assets#create'
  end

  namespace :admin do
    root 'main#index'
    resources :menu_items
    resources :admins
    resources :pages
    resource :setting, only: [:edit, :update]
  end

  scope module: :application do
    root 'main#index'
    match '/:locale' => 'main#index', locale: /#{I18n.available_locales.join('|')}/, via: [:get, :post]
    post '/', to: 'main#index'
    get 'news/index'
    get 'news/page'
    get 'news/block'
    get 'question/new'
    post 'question/send'
    get ':url' => 'main#index'
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
  #   namespace :admins do
  #     # Directs /admins/products/* to Admin::ProductsController
  #     # (app/controllers/admins/products_controller.rb)
  #     resources :products
  #   end
end
