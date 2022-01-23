require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context 'for unauthorized users' do
    let(:user) { create :user }

    before(:each) do
      sign_in_as user
    end

    shared_examples_for 'rejects access to unauthorized users' do |method, action, params = {}|
      it 'should not be accessible' do
        send(method.to_sym, action, params: params)

        expect(response.status).to eq 403
      end
    end

    describe '#index' do
      it_behaves_like 'rejects access to unauthorized users', :get, :index
    end

    describe '#show' do
      it_behaves_like 'rejects access to unauthorized users', :get, :show, { id: 1 }
    end

    describe '#create' do
      it_behaves_like 'rejects access to unauthorized users', :post, :create
    end

    describe '#update' do
      it_behaves_like 'rejects access to unauthorized users', :patch, :update, { id: 1 }
    end

    describe '#destroy' do
      it_behaves_like 'rejects access to unauthorized users', :delete, :destroy, { id: 1 }
    end

    describe '#activate' do
      it_behaves_like 'rejects access to unauthorized users', :post, :activate, { id: 1 }
    end

    describe '#deactivate' do
      it_behaves_like 'rejects access to unauthorized users', :delete, :deactivate, { id: 1 }
    end
  end

  context 'for authorized users' do
    let(:admin) { create :admin }

    before(:each) do
      sign_in_as admin
    end

    describe "#index" do
      let!(:users) { create_list :user, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:user) { create :user }

      it "renders a successful response" do
        get :show, params: { id: user.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq user.id.to_s
      end
    end

    describe "#create" do
      let(:valid_params) { {
        first_name: "First",
        last_name: "Last",
        email: "test@test.test",
        phone: "+421900123456",
        password: "pass",
        active: "true"
      } }

      let(:invalid_params) { {
        first_name: "First",
        last_name: "Last",
        email: "test@",
        phone: "+421900123456",
        password: "pass",
        active: "true"
      } }

      context "with valid parameters" do
        it "creates a new User" do
          expect {
            post :create, params: { user: valid_params }
          }.to change(User, :count).by(1)
        end
        it "renders a JSON response with the new user" do
          post :create, params: { user: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 1
          expect(response_json["data"]).to have_key "id"
        end
      end

      context "with invalid parameters" do
        it "does not create a new User" do
          expect {
            post :create, params: { user: invalid_params }
          }.to change(User, :count).by(0)
        end
        it "renders a JSON response with errors for the new user" do
          post :create, params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      it "does not create a duplicate user" do
        post :create, params: { user: valid_params }
        expect {
          post :create, params: { user: valid_params }
        }.to change(User, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
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
        it "updates the requested user" do
          patch :update, params: { id: user.id, user: valid_new_params }
          user.reload

          expect(user.first_name).to eq(valid_new_params[:first_name])
          expect(user.last_name).to eq(valid_new_params[:last_name])
          expect(user.email).to eq(valid_new_params[:email])
          expect(user.phone).to eq(valid_new_params[:phone])
        end
        it "renders a JSON response with the user" do
          patch :update, params: { id: user.id, user: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the user" do
          patch :update, params: { id: user.id, user: invalid_new_params }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "#destroy" do
      let!(:user) { create :user }

      it "destroys the requested user" do
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)
      end
    end

    describe "#activate" do
      let!(:user) { create :user, active: false }

      it "activates the user" do
        expect(user.active).to eq(false)

        post :activate, params: { id: user.id }
        user.reload

        expect(user.active).to eq(true)
      end
    end

    describe "#deactivate" do
      let!(:user) { create :user, active: true }

      it "deactivates the user" do
        expect(user.active).to eq(true)

        post :deactivate, params: { id: user.id }
        user.reload

        expect(user.active).to eq(false)
      end
    end
  end
end