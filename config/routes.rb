Rails.application.routes.draw do
  scope '/', defaults: { format: 'json' }, as: :api do
    get 'me', controller: :users, action: :me
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
    get ':id', action: :show
    post '', action: :create
    patch ':id', action: :update
    delete ':id', action: :destroy
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
  end

  # Roles
  scope 'roles', controller: :roles do
    get '', action: :index
    get ':id', action: :show
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "application#bad_request"
end
