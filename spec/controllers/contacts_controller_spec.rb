require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
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
  end

  context 'for authorized users' do
    let(:user) { create :user }

    before(:each) do
      sign_in_as user
    end

    describe "#index" do
      let!(:contacts) { create_list :contact, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:contact) { create :contact }

      it "renders a successful response" do
        get :show, params: { id: contact.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq contact.id.to_s
      end
    end

    describe "#create" do
      let(:valid_params) { {
        first_name: "First",
        last_name: "Last",
        email: "test@test.test",
        phone: "+421900123456"
      } }

      let(:invalid_params) { {
        first_name: "First",
        last_name: "Last",
        email: "test@",
        phone: "+421900123456"
      } }

      context "with valid parameters" do
        it "creates a new Contact" do
          expect {
            post :create, params: { contact: valid_params }
          }.to change(Contact, :count).by(1)
        end
        it "renders a JSON response with the new contact" do
          post :create, params: { contact: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 1
          expect(response_json["data"]).to have_key "id"
        end
      end

      context "with invalid parameters" do
        it "does not create a new Contact" do
          expect {
            post :create, params: { contact: invalid_params }
          }.to change(Contact, :count).by(0)
        end
        it "renders a JSON response with errors for the new contact" do
          post :create, params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "#update" do
      let!(:contact) { create :contact }

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
        it "updates the requested contact" do
          patch :update, params: { id: contact.id, contact: valid_new_params }
          contact.reload

          expect(contact.first_name).to eq(valid_new_params[:first_name])
          expect(contact.last_name).to eq(valid_new_params[:last_name])
          expect(contact.email).to eq(valid_new_params[:email])
          expect(contact.phone).to eq(valid_new_params[:phone])
        end
        it "renders a JSON response with the contact" do
          patch :update, params: { id: contact.id, contact: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the contact" do
          patch :update, params: { id: contact.id, contact: invalid_new_params }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "#destroy" do
      let!(:contact) { create :contact }

      it "destroys the requested contact" do
        expect {
          delete :destroy, params: { id: contact.id }
        }.to change(Contact, :count).by(-1)
      end
    end
  end
end
