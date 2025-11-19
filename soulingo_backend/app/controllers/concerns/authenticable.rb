module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  private

  def authenticate_request
    token = extract_token_from_header
    return render_unauthorized unless token

    decoded_token = JwtService.decode(token)
    return render_unauthorized unless decoded_token

    @current_user = User.find_by(id: decoded_token[:sub])
    return render_unauthorized unless @current_user
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return nil unless auth_header

    auth_header.split(' ').last if auth_header.start_with?('Bearer ')
  end

  def render_unauthorized
    render json: {
      error: {
        code: 'unauthorized',
        message: 'Invalid or missing authentication token'
      }
    }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end

