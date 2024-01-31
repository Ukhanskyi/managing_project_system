require 'devise/jwt/test_helpers'

module AuthHelper
  def auth_token(user)
    auth_headers = Devise::JWT::TestHelpers.auth_headers({}, user)
    auth_headers['Authorization']
  end
end
