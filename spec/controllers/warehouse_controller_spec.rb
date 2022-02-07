require 'rails_helper'

RSpec.describe WarehousesController, type: :controller do
  context 'for unauthorized users' do
    let(:user) { create :user }

    before(:each) do
      sign_in_as user
    end

    describe '#index' do
      it_behaves_like 'rejects access to unauthorized users', :get, :index, {}, [403]
    end

    describe '#show' do
      it_behaves_like 'rejects access to unauthorized users', :get, :show, { id: 1 }, [403, 404]
    end

    describe '#create' do
      it_behaves_like 'rejects access to unauthorized users', :post, :create, {}, [403]
    end

    describe '#update' do
      it_behaves_like 'rejects access to unauthorized users', :patch, :update, { id: 1 }, [403, 404]
    end

    describe '#destroy' do
      it_behaves_like 'rejects access to unauthorized users', :delete, :destroy, { id: 1 }, [403, 404]
    end
  end

  context 'for authorized users' do
    let(:manager) { create :manager }

    before(:each) do
      sign_in_as manager
    end

    describe "#index" do
      let!(:warehouses) { create_list :warehouse, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:warehouse) { create :warehouse }

      it "renders a successful response" do
        get :show, params: { id: warehouse.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq warehouse.id.to_s
      end
    end

    describe "#create" do
      let(:valid_params) { {
        name: 'Warehouse custom',
        street_name: '52nd Street',
        street_number: '123',
        city: 'New York',
        country: 'USA'
      } }

      context "with valid parameters" do
        it "creates a new Warehouse" do
          expect {
            post :create, params: { warehouse: valid_params }
          }.to change(Warehouse, :count).by(1)
        end
        it "renders a JSON response with the new Vendor" do
          post :create, params: { warehouse: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 1
          expect(response_json["data"]).to have_key "id"
        end
      end
    end

    describe "#update" do
      let!(:warehouse) { create :warehouse }

      let(:valid_new_params) { {
        name: 'Warehouse update',
        street_name: '51nd Street',
        street_number: '321',
        city: 'New New York',
        country: 'USAA'
      } }

      context "with valid parameters" do
        it "updates the requested warehouse" do
          patch :update, params: { id: warehouse.id, warehouse: valid_new_params }
          warehouse.reload

          expect(warehouse.name).to eq(valid_new_params[:name])
          expect(warehouse.street_name).to eq(valid_new_params[:street_name])
          expect(warehouse.street_number).to eq(valid_new_params[:street_number])
          expect(warehouse.city).to eq(valid_new_params[:city])
          expect(warehouse.country).to eq(valid_new_params[:country])
        end
        it "renders a JSON response with the warehouse" do
          patch :update, params: { id: warehouse.id, warehouse: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#destroy" do
      let!(:warehouse) { create :warehouse }

      it "destroys the requested warehouse" do
        expect {
          delete :destroy, params: { id: warehouse.id }
        }.to change(Warehouse, :count).by(-1)
      end
    end
  end
end