require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
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
      let!(:locations) { create_list :location, 3 }

      it "renders a successful response" do
        get :index

        expect(response).to be_successful
      end
    end

    describe "#show" do
      let!(:location) { create :location }

      it "renders a successful response" do
        get :show, params: { id: location.id }

        expect(response).to be_successful
        expect(response_json["data"]["id"]).to eq location.id.to_s
      end
    end

    describe "#create" do
      let!(:room) { create :room }
      let(:valid_params) { {
        name: 'Location custom',
        room_id: room.id
      } }

      context "with valid parameters" do
        it "creates a new Location" do
          expect {
            post :create, params: { location: valid_params }
          }.to change(Location, :count).by(1)
        end
        it "renders a JSON response with the new Location" do
          post :create, params: { location: valid_params }

          expect(response).to have_http_status(:created)
          expect(response_json.size).to eq 1
          expect(response_json["data"]).to have_key "id"
        end
      end
    end

    describe "#update" do
      let!(:room_one) { create :room }
      let!(:room_two) { create :room }
      let!(:location) { create :location, room: room_one }

      let(:valid_new_params) { {
        name: 'Location update',
        room_id: room_two.id
      } }

      context "with valid parameters" do
        it "updates the requested room" do
          patch :update, params: { id: location.id, location: valid_new_params }
          location.reload

          expect(location.name).to eq(valid_new_params[:name])
          expect(location.room.id).to eq(valid_new_params[:room_id])
        end
        it "renders a JSON response with the Location" do
          patch :update, params: { id: location.id, location: valid_new_params }

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#destroy" do
      let!(:location) { create :location }

      it "destroys the requested Location" do
        expect {
          delete :destroy, params: { id: location.id }
        }.to change(Location, :count).by(-1)
      end
    end
  end
end