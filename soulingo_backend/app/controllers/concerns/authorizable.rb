module Authorizable
  extend ActiveSupport::Concern

  private

  # Admin rolü gerektirir
  def require_admin!
    return if current_user&.role == 'admin'

    render_forbidden('Admin access required')
    return
  end

  # Kullanıcı kendi kaynağına erişiyor mu veya admin mi kontrol eder
  def require_self_or_admin!(resource_user_id)
    return if current_user&.role == 'admin'
    return if current_user&.id == resource_user_id

    render_forbidden('Access denied. You can only access your own resources.')
    return
  end

  # Sadece kendi kaynağına erişim (admin bile kendi kaynağına erişmeli)
  def require_self!(resource_user_id)
    return if current_user&.id == resource_user_id

    render_forbidden('Access denied. You can only access your own resources.')
    return
  end

  def render_forbidden(message = 'Access denied')
    render json: {
      error: {
        code: 'forbidden',
        message: message
      }
    }, status: :forbidden
  end
end

