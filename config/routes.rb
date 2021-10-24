Rails.application.routes.draw do
	scope '/', defaults: { format: 'json' }, as: :api do
		get 'me', controller: :users, action: :me
		post 'refresh', controller: :refresh, action: :create
		post 'signin', controller: :sign_in, action: :create
		post 'signup', controller: :sign_up, action: :create
		delete 'signin', controller: :sign_in, action: :destroy
	end

	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	root to: "application#bad_request"
end
