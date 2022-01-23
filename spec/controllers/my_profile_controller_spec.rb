require 'rails_helper'

RSpec.describe MyProfileController, type: :controller do
  context 'for unauthorized users' do
    shared_examples_for 'rejects access to unauthorized users' do |method, action, params = {}|
      it 'should not be accessible' do
        send(method.to_sym, action, params: params)

        expect(response.status).to eq 401
      end
    end

    describe '#index' do
      it_behaves_like 'rejects access to unauthorized users', :get, :index
    end

    describe '#update' do
      it_behaves_like 'rejects access to unauthorized users', :patch, :update, { id: 1 }
    end
  end

  context 'for authorized users' do
    let(:user) { create :user }

    before(:each) do
      sign_in_as user
    end

    describe "#index" do
      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#update" do
      let!(:user) { create :user }

      let(:valid_new_params) { {
        first_name: "New First",
        last_name: "New Last",
        email: "new@test.test",
        phone: "+421900123457"
      } }

      let(:invalid_new_params) { {
        first_name: "New First",
        last_name: "New Last",
        email: "new@",
        phone: "+421900123457"
      } }

      context "with valid parameters" do
        it "updates the logged in user" do
          patch :update, params: { user: valid_new_params }
          user.reload

          expect(user.first_name).to eq(valid_new_params[:first_name])
          expect(user.last_name).to eq(valid_new_params[:last_name])
          expect(user.email).to eq(valid_new_params[:email])
          expect(user.phone).to eq(valid_new_params[:phone])
        end
        it "renders a JSON response with the user" do
          patch :update, params: { user: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the logged in user" do
          patch :update, params: { id: user.id, user: invalid_new_params }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end