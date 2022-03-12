Rails.application.routes.draw do
  scope '/', defaults: { format: 'json' }, as: :api do
    post 'refresh', controller: :refresh, action: :create
    post 'signin', controller: :sign_in, action: :create
    scope 'signup', controller: :sign_up do
      post '/', action: :create
      post 'activate', action: :activate
    end
    delete 'signin', controller: :sign_in, action: :destroy
  end

  # Contacts
  scope 'contacts', controller: :contacts do
    get '', action: :index
    get 'select-options', action: :select_options
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
    delete ':id/avatar', action: :destroy_avatar
  end

  # Users
  scope 'users', controller: :users do
    get '', action: :index
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    post ':id/activation', action: :activate
    delete ':id/activation', action: :deactivate
    delete ':id', action: :destroy
    delete ':id/avatar', action: :destroy_avatar
  end

  # Roles
  scope 'roles', controller: :roles do
    get '', action: :index
    get ':id', action: :show
  end

  # My profile
  scope 'my-profile', controller: :my_profile do
    get '', action: :index
    patch '', action: :update
    delete 'avatar', action: :destroy_avatar
  end

  # Vendors
  scope 'vendors', controller: :vendors do
    get '', action: :index
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
    delete ':id/logo', action: :destroy_logo
  end

  # Warehouses
  scope 'warehouses', controller: :warehouses do
    get '', action: :index
    get 'select-options', action: :select_options
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
  end

  # Rooms
  scope 'rooms', controller: :rooms do
    get '', action: :index
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
  end

  # Suppliers
  scope 'suppliers', controller: :suppliers do
    get '', action: :index
    get 'select-options', action: :select_options
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
  end

  # Products
  scope 'products', controller: :products do
    get '', action: :index
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
  end

  # Image auth
  scope 'verify-image', controller: :verify_image do
    get ':sgid', action: :verify_image
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "application#bad_request"
end
