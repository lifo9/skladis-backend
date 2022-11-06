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
    get 'select-options', action: :select_options
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
    get 'select-options', action: :select_options
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
  end

  # Locations
  scope 'locations', controller: :locations do
    get '', action: :index
    get 'select-options', action: :select_options
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
    get 'select-options', action: :select_options
    get ':id', action: :show
    get ':id/price-history', action: :price_history
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
  end

  # Invoices
  scope 'invoices', controller: :invoices do
    get '', action: :index
    get 'invoice-date-range', action: :invoice_date_range
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    patch ':id/stocked-in', action: :update_stocked_in
    delete ':id', action: :destroy
    delete ':id/invoice-file', action: :destroy_invoice_file
  end

  # Invoice Items
  scope 'invoice-items', controller: :invoice_items do
    get '', action: :index
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
  end

  # Audits
  scope 'audits', controller: :audits do
    get '', action: :index
    get 'select-options', action: :select_options
  end

  # Stocks
  scope 'stocks', controller: :stocks do
    get '', action: :index
    get 'expiration-range', action: :expiration_range
    post 'in', action: :stock_in
    post 'out', action: :stock_out
    post 'transfer', action: :stock_transfer
    get ':id', action: :show
  end

  # Stock Transactions
  scope 'stock-transactions', controller: :stock_transactions do
    get '', action: :index
    get 'created-at-range', action: :created_at_range
    get ':id', action: :show
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "application#bad_request"
end
