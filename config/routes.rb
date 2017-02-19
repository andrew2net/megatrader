Rails.application.routes.draw do

  # namespace :application do
  # get 'static_pages/show'
  # end

  filter :locale, exclude: /^\/(admin|tinymce_assets|admin_session|api\/|.*?\.(?!(json|js)).*$)/

  post 'admin_session/create', to: 'admin_session#create'
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
    get 'licenses/view'
    get 'licenses/products'
    resources :licenses, defaults: { action: :licenses } do
      get :logs
    end
    get 'users/index'
  end

  scope module: :application do
    root 'main#index'
    scope :api do
      controller :api do
        get 'tools'
        get 'correlations'
        get 'tool_symbols'
        post :spread
        post :pairs
        post :license
        get '/download/:token', action: :download
      end
    end
    scope :users do
      controller :users do
        post :email
      end
    end
    # post '/users/email', to: 'users#email'
    # match '/:locale' => 'main#index', locale: /#{I18n.available_locales.join('|')}/, via: [:get, :post]
    post '/', to: 'main#index'
    # get 'news/index'
    get 'novosti/:url', to: 'main#news', constraints: {locale: /ru/}, as: :news_ru
    get 'novosti-en/:url', to: 'main#news',
      constraints: {locale: /en/}, as: :news_en
    # get 'news/block'
    get 'question/new'
    post 'question/send_message'
    get 'poleznaja-informacija', to: 'main#articles',
      constraints: {locale: /ru/}, as: :articles_ru
    get 'poleznaja-informacija/:url', to: 'main#article',
      constraints: {locale: /ru/}, as: :article_ru
    get 'poleznaja-informacija-en', to: 'main#articles',
      constraints: {locale: /en/}, as: :articles_en
    get 'poleznaja-informacija-en/:url', to: 'main#article',
      constraints: {locale: /en/}, as: :article_en
    get ':url' => 'main#index', as: :page
    if Rails.env == 'development'
      match '*path', to: 'main#not_found', via: :all,
        constraints: {path: /(?!\/rails\/).*/}, as: :not_found
    else
      match '*path', to: 'main#not_found', via: :all, as: :not_found
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
  #   namespace :admins do
  #     # Directs /admins/products/* to Admin::ProductsController
  #     # (app/controllers/admins/products_controller.rb)
  #     resources :products
  #   end
end
