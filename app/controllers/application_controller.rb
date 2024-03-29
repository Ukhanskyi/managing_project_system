# Application Controller
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end
end
