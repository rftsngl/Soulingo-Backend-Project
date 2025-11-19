require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      course = Course.new(
        title: 'Test Course',
        language_code: 'en',
        level: 'A1',
        is_published: true
      )
      expect(course).to be_valid
    end

    it 'is invalid without title' do
      course = Course.new(language_code: 'en', level: 'A1')
      expect(course).not_to be_valid
      expect(course.errors[:title]).to include("can't be blank")
    end

    it 'is invalid with title longer than 120 characters' do
      course = Course.new(title: 'a' * 121, language_code: 'en', level: 'A1')
      expect(course).not_to be_valid
    end

    it 'is invalid without language_code' do
      course = Course.new(title: 'Test Course', level: 'A1')
      expect(course).not_to be_valid
      expect(course.errors[:language_code]).to include("can't be blank")
    end

    it 'is invalid with invalid level' do
      course = Course.new(title: 'Test Course', language_code: 'en', level: 'X1')
      expect(course).not_to be_valid
      expect(course.errors[:level]).to be_present
    end

    it 'defaults is_published to false' do
      course = Course.create!(title: 'Test Course', language_code: 'en', level: 'A1')
      expect(course.is_published).to be_falsey
    end
  end

  describe 'associations' do
    let(:course) { Course.create!(title: 'Test Course', language_code: 'en', level: 'A1', is_published: true) }

    it 'has many lessons' do
      lesson = Lesson.create!(course: course, title: 'Test Lesson', order_index: 1)
      expect(course.lessons).to include(lesson)
    end

    it 'has many enrollments' do
      user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student')
      enrollment = Enrollment.create!(user: user, course: course, status: 'active')
      expect(course.enrollments).to include(enrollment)
    end

    it 'has many users through enrollments' do
      user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student')
      Enrollment.create!(user: user, course: course, status: 'active')
      expect(course.users).to include(user)
    end
  end
end

