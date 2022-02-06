require 'rails_helper'

RSpec.describe VendorsController, type: :controller do
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

    describe '#destroy_logo' do
      it_behaves_like 'rejects access to unauthorized users', :delete, :destroy_logo, { id: 1 }
    end
  end

  context 'for authorized users' do
    let(:user) { create :user }

    before(:each) do
      sign_in_as user
    end

    describe "#index" do
      let!(:vendors) { create_list :vendor, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:vendor) { create :vendor }

      it "renders a successful response" do
        get :show, params: { id: vendor.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq vendor.id.to_s
      end
    end

    describe "#create" do
      let(:valid_params) { {
        name: "Vendor name",
        url: "https://vendor-domain.skladis.com"
      } }

      context "with valid parameters" do
        it "creates a new Vendor" do
          expect {
            post :create, params: { vendor: valid_params }
          }.to change(Vendor, :count).by(1)
        end
        it "renders a JSON response with the new Vendor" do
          post :create, params: { vendor: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 1
          expect(response_json["data"]).to have_key "id"
        end
      end
    end

    describe "#update" do
      let!(:vendor) { create :vendor }

      let(:valid_new_params) { {
        name: "New vendor name",
        url: "https://new-vendor-domain.skladis.com"
      } }

      context "with valid parameters" do
        it "updates the requested vendor" do
          patch :update, params: { id: vendor.id, vendor: valid_new_params }
          vendor.reload

          expect(vendor.name).to eq(valid_new_params[:name])
          expect(vendor.url).to eq(valid_new_params[:url])
        end
        it "renders a JSON response with the vendor" do
          patch :update, params: { id: vendor.id, vendor: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#destroy" do
      let!(:vendor) { create :vendor }

      it "destroys the requested vendor" do
        expect {
          delete :destroy, params: { id: vendor.id }
        }.to change(Vendor, :count).by(-1)
      end
    end

    describe "#destroy_logo" do
      let!(:vendor) { create :vendor }

      it "deletes the vendor's logo" do
        expect(vendor.logo.attached?).to eq(true)

        delete :destroy_logo, params: { id: vendor.id }
        vendor.reload

        expect(vendor.logo.attached?).to eq(false)
      end
    end
  end
end