require 'swagger_helper'

TAGS_CURRENT_USERS = 'Current User'.freeze

RSpec.describe 'Api::V1::CurrentUsersController', type: :request do
  let(:user)          { FactoryBot.create(:user) }
  let(:Authorization) { auth_token(user) }

  path '/api/v1/current_users' do
    get('Returns authorized current user') do
      tags TAGS_CURRENT_USERS

      security [jwt: []]

      response(200, 'successful') do
        it 'returns current_user' do
          data = JSON(response.body)

          expect(data['id']).to eq(user.id)
          expect(response).to have_http_status(:success)
        end

        run_test!
      end
    end
  end
end
