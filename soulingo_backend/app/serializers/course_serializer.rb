class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :language_code, :level, :description, :is_published, :created_at, :updated_at

  # İlişkili veriler (opsiyonel)
  attribute :lessons_count, if: :include_lessons_count?

  def lessons_count
    object.lessons.count
  end

  def include_lessons_count?
    instance_options[:include_lessons_count] == true
  end
end

