require 'rails_helper'

RSpec.describe 'CurrentUsers', type: :request do # rubocop:disable Metrics/BlockLength
  let(:user) { FactoryBot.create(:user) }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  describe 'GET /index' do
    context 'Request it with authenticated requests' do
      before do
        post user_session_url, params:
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the token' do
        expect(response.headers['authorization']).to be_present
      end

      it 'returns the user' do
        get current_user_url, headers: { Authorization: response.headers['Authorization'] }

        current_user = response.parsed_body

        expect(current_user['id']).to eq(user.id)
        expect(current_user['email']).to eq(user.email)
      end
    end

    context 'Request it without authenticated requests' do
      it 'returns 401' do
        get current_user_url

        expect(response.status).to eq(401)
      end
    end
  end
end
