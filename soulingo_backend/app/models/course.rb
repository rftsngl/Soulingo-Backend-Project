class Course < ApplicationRecord
  # Validations
  validates :title, presence: true, length: { maximum: 120 }
  validates :language_code, presence: true
  validates :level, inclusion: { in: %w[A1 A2 B1 B2 C1 C2] }, allow_nil: true

  # Relationships
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
end

