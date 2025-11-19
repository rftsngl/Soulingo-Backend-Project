class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, presence: true, 
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[student admin] }

  # Relationships
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :session_analyses, dependent: :destroy
end

