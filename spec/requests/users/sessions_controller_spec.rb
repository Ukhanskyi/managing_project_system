require 'rails_helper'

RSpec.describe 'SessionsController', type: :request do # rubocop:disable Metrics/BlockLength
  let(:user) { FactoryBot.create(:user) }
  let(:valid_user_params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end
  let(:invalid_user_params) do
    {
      user: {
        email: user.email,
        password: nil
      }
    }
  end

  describe 'POST /login' do
    context 'When logging in' do
      before do
        post user_session_url, params: valid_user_params
      end

      it 'returns a token' do
        expect(response.headers['Authorization']).to be_present
      end

      it 'returns 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'When password is missing' do
      before do
        post user_session_url, params: invalid_user_params
      end

      it 'returns 401' do
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST /logout' do
    context 'When logging out' do
      before do
        post user_session_url, params: valid_user_params
        delete destroy_user_session_url
      end

      it 'returns 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
