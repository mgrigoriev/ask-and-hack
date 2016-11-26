require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "returns user #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid' do
        get '/api/v1/profiles', params: { access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users.first.id) }

      before do
        get '/api/v1/profiles', params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns all users with specific attributes, except of current user' do
        response_items = JSON.parse(response.body)
        attrs = %w(id email created_at updated_at admin)

        expect(response_items.size).to eq(2)
        expect(response_items[0].sort.to_json).to eq(users[1].attributes.slice(*attrs).sort.to_json)
        expect(response_items[1].sort.to_json).to eq(users[2].attributes.slice(*attrs).sort.to_json)
      end
    end
  end

end
