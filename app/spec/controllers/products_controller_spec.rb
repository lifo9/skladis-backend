require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  context 'for unauthorized users' do
    let(:user) { create :user }

    before(:each) do
      sign_in_as user
    end

    describe '#index' do
      it_behaves_like 'rejects access to unauthorized users', :get, :index, {}, [403]
    end

    describe '#select_options' do
      it_behaves_like 'rejects access to unauthorized users', :get, :select_options, { id: 1 }, [403]
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
      let!(:products) { create_list :product, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#select_options" do
      let!(:products) { create_list :product, 3 }

      it "renders a successful response" do
        get :select_options

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:product) { create :product }

      it "renders a successful response" do
        get :show, params: { id: product.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq product.id.to_s
      end
    end

    describe "#create" do
      let(:suppliers) { create_list :supplier, 3 }
      let(:valid_params) { {
        name: "Product name",
        order_code: "ORDER_CODE_321",
        pieces_ideal: 20,
        pieces_critical: 10,
        barcode_type: 'ean',
        barcode_code: '312312',
        supplier_ids: suppliers.map(&:id)
      } }

      context "with valid parameters" do
        it "creates a new Product" do
          expect {
            post :create, params: { product: valid_params }
          }.to change(Product, :count).by(1)
        end
        it "renders a JSON response with the new Product" do
          post :create, params: { product: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 2
          expect(response_json["data"]).to have_key "id"
        end
      end
    end

    describe "#update" do
      let(:supplier) { create :supplier }
      let!(:product) { create :product, :with_supplier }

      let(:valid_new_params) { {
        name: "New product name",
        order_code: "ORDER_CODE_666",
        pieces_ideal: 14,
        pieces_critical: 7,
        barcode_type: 'ean_9',
        barcode_code: '3112356',
        supplier_ids: [supplier.id]
      } }

      context "with valid parameters" do
        it "updates the requested product" do
          patch :update, params: { id: product.id, product: valid_new_params }
          product.reload

          expect(product.name).to eq(valid_new_params[:name])
          expect(product.order_code).to eq(valid_new_params[:order_code])
          expect(product.pieces_ideal).to eq(valid_new_params[:pieces_ideal])
          expect(product.pieces_ideal).to eq(valid_new_params[:pieces_ideal])
          expect(product.barcode.barcode_type).to eq(valid_new_params[:barcode_type])
          expect(product.barcode.barcode_code).to eq(valid_new_params[:barcode_code])
          expect(product.pieces_critical).to eq(valid_new_params[:pieces_critical])
        end
        it "renders a JSON response with the product" do
          patch :update, params: { id: product.id, product: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#destroy" do
      let!(:product) { create :product }

      it "destroys the requested Product" do
        expect {
          delete :destroy, params: { id: product.id }
        }.to change(Product, :count).by(-1)
      end
    end
  end
end