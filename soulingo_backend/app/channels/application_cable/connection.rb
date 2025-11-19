module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # JWT token'ı query string veya header'dan al
      token = request.params[:token] || extract_token_from_header

      if token.blank?
        reject_unauthorized_connection
        return
      end

      decoded_token = JwtService.decode_token(token)
      if decoded_token.nil?
        reject_unauthorized_connection
        return
      end

      user = User.find_by(id: decoded_token['sub'])
      if user.nil?
        reject_unauthorized_connection
        return
      end

      user
    rescue ActiveRecord::RecordNotFound
      reject_unauthorized_connection
    end

    def extract_token_from_header
      # ActionCable bağlantılarında Authorization header'ı genellikle query string'de gelir
      # Ancak bazı client'lar header'da gönderebilir
      auth_header = request.headers['Authorization'] || request.headers['authorization']
      return nil if auth_header.blank?

      # "Bearer <token>" formatından token'ı çıkar
      auth_header.split(' ').last if auth_header.start_with?('Bearer ')
    end
  end
end

