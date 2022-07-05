require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
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
      let!(:suppliers) { create_list :supplier, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#select_options" do
      let!(:suppliers) { create_list :supplier, 3 }

      it "renders a successful response" do
        get :select_options

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:supplier) { create :supplier }

      it "renders a successful response" do
        get :show, params: { id: supplier.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq supplier.id.to_s
      end
    end

    describe "#create" do
      let!(:contact) { create :contact }
      let(:valid_params) { {
        name: 'Supplier custom',
        ico: "4234554645",
        dic: "78668767",
        ic_dph: "SK12345",
        url: "https://supplier-custom.com",
        street_name: '52nd Street',
        street_number: '123',
        city: 'New York',
        zip: '123',
        country: 'USA',
        coordinates: [1, 2],
        contact_id: contact.id
      } }

      context "with valid parameters" do
        it "creates a new Supplier" do
          expect {
            post :create, params: { supplier: valid_params }
          }.to change(Supplier, :count).by(1)
        end
        it "renders a JSON response with the new Supplier" do
          post :create, params: { supplier: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 2
          expect(response_json["data"]).to have_key "id"
        end
      end
    end

    describe "#update" do
      let!(:supplier) { create :supplier }

      let!(:contact) { create :contact }
      let(:valid_new_params) { {
        name: 'Supplier custom 2',
        ico: "42345546415",
        dic: "786687617",
        ic_dph: "CZ54321",
        url: "https://supplier-custom-2.com",
        street_name: '53nd Street',
        street_number: '321',
        city: 'London',
        zip: '111',
        country: 'UK',
        coordinates: [3, 4],
        contact_id: contact.id
      } }

      context "with valid parameters" do
        it "updates the requested Supplier" do
          patch :update, params: { id: supplier.id, supplier: valid_new_params }
          supplier.reload

          expect(supplier.name).to eq(valid_new_params[:name])
          expect(supplier.ico).to eq(valid_new_params[:ico])
          expect(supplier.dic).to eq(valid_new_params[:dic])
          expect(supplier.ic_dph).to eq(valid_new_params[:ic_dph])
          expect(supplier.url).to eq(valid_new_params[:url])
          expect(supplier.address.street_name).to eq(valid_new_params[:street_name])
          expect(supplier.address.street_number).to eq(valid_new_params[:street_number])
          expect(supplier.address.city).to eq(valid_new_params[:city])
          expect(supplier.address.zip).to eq(valid_new_params[:zip])
          expect(supplier.address.country).to eq(valid_new_params[:country])
          expect(supplier.address.coordinates.to_a).to eq(valid_new_params[:coordinates])
          expect(supplier.contact.id).to eq(valid_new_params[:contact_id])
        end
        it "renders a JSON response with the Supplier" do
          patch :update, params: { id: supplier.id, supplier: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#destroy" do
      let!(:supplier) { create :supplier }

      it "destroys the requested Supplier" do
        expect {
          delete :destroy, params: { id: supplier.id }
        }.to change(Supplier, :count).by(-1)
      end
    end
  end
end