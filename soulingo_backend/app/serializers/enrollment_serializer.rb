class EnrollmentSerializer < ActiveModel::Serializer
  attributes :id, :status, :progress_percent, :started_at, :completed_at, :created_at, :updated_at

  belongs_to :user
  belongs_to :course

  attribute :user_email, if: :include_user_email?
  attribute :course_title, if: :include_course_title?

  def user_email
    object.user.email
  end

  def include_user_email?
    instance_options[:include_user_email] == true
  end

  def course_title
    object.course.title
  end

  def include_course_title?
    instance_options[:include_course_title] == true
  end
end

