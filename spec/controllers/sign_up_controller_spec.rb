require 'rails_helper'

RSpec.describe SignUpController, type: :controller do

	describe 'POST #create' do
    let(:invitation) { create(:registration_invitation) }

    let(:user_params_invalid) { {
			email: 'test@test.test',
			password: 'password',
			password_confirmation: 'password',
			first_name: 'First',
			last_name: 'Last',
		} }

		let(:user_params_valid) { {
			email: 'test@test.test',
			password: 'password',
			password_confirmation: 'password',
			first_name: 'First',
			last_name: 'Last',
      registration_key: invitation.key
		} }

		it 'returns unauthorized when registration key missing or wrong' do
			post :create, params: user_params_invalid
			expect(response).to have_http_status(401)
		end

		it 'returns http success' do
			post :create, params: user_params_valid
			expect(response).to be_successful
			expect(response_json.keys).to eq ['csrf']
			expect(response.cookies[JWTSessions.access_cookie]).to be_present
		end

		it 'creates a new user' do
			expect do
				post :create, params: user_params_valid
			end.to change(User, :count).by(1)
		end
	end
end
