require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
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
      let!(:rooms) { create_list :room, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:room) { create :room }

      it "renders a successful response" do
        get :show, params: { id: room.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq room.id.to_s
      end
    end

    describe "#create" do
      let!(:warehouse) { create :warehouse }
      let(:valid_params) { {
        name: 'Room custom',
        warehouse_id: warehouse.id
      } }

      context "with valid parameters" do
        it "creates a new Room" do
          expect {
            post :create, params: { room: valid_params }
          }.to change(Room, :count).by(1)
        end
        it "renders a JSON response with the new Vendor" do
          post :create, params: { room: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 2
          expect(response_json["data"]).to have_key "id"
        end
      end
    end

    describe "#update" do
      let!(:warehouse_one) { create :warehouse }
      let!(:warehouse_two) { create :warehouse }
      let!(:room) { create :room, warehouse: warehouse_one }

      let(:valid_new_params) { {
        name: 'Room update',
        warehouse_id: warehouse_two.id
      } }

      context "with valid parameters" do
        it "updates the requested room" do
          patch :update, params: { id: room.id, room: valid_new_params }
          room.reload

          expect(room.name).to eq(valid_new_params[:name])
          expect(room.warehouse.id).to eq(valid_new_params[:warehouse_id])
        end
        it "renders a JSON response with the room" do
          patch :update, params: { id: room.id, room: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#destroy" do
      let!(:room) { create :room }

      it "destroys the requested room" do
        expect {
          delete :destroy, params: { id: room.id }
        }.to change(Room, :count).by(-1)
      end
    end
  end
end