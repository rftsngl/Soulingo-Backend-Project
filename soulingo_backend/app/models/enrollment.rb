class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  # Validations
  validates :user_id, presence: true
  validates :course_id, presence: true
  validates :status, inclusion: { in: %w[active completed dropped] }
  validates :progress_percent, numericality: { in: 0..100 }
  validates :user_id, uniqueness: { scope: :course_id, message: "has already enrolled in this course" }
end

