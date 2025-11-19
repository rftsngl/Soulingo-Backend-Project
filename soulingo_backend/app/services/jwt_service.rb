class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base || Rails.application.secret_key_base
  EXPIRATION_TIME = 24.hours.to_i # 86400 saniye

  class << self
    # JWT token oluştur
    def encode(payload)
      payload[:exp] = Time.now.to_i + EXPIRATION_TIME
      payload[:iat] = Time.now.to_i
      JWT.encode(payload, SECRET_KEY, 'HS256')
    end

    # JWT token decode et
    def decode(token)
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
      decoded[0].with_indifferent_access
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      nil
    end

    # User'dan token oluştur
    def token_for(user)
      encode(
        sub: user.id,
        role: user.role
      )
    end

    # Token'dan user_id al
    def user_id_from_token(token)
      decoded = decode(token)
      decoded&.dig(:sub)
    end

    # Token'dan role al
    def role_from_token(token)
      decoded = decode(token)
      decoded&.dig(:role)
    end
  end
end

