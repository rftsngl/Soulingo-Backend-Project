class LessonSerializer < ActiveModel::Serializer
  attributes :id, :title, :order_index, :description, :video_url, :expected_duration_minutes, :created_at, :updated_at

  belongs_to :course

  attribute :course_title, if: :include_course_title?

  def course_title
    object.course.title
  end

  def include_course_title?
    instance_options[:include_course_title] == true
  end
end

