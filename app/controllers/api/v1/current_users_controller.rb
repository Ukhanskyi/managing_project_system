module Api
  module V1
    # Current Users Controller
    class CurrentUsersController < ApplicationController
      before_action :authenticate_user!

      def index
        render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
               status: :ok
      end
    end
  end
end
