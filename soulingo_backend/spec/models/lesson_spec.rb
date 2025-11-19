require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:course) { Course.create!(title: 'Test Course', language_code: 'en', level: 'A1', is_published: true) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      lesson = Lesson.new(course: course, title: 'Test Lesson', order_index: 1)
      expect(lesson).to be_valid
    end

    it 'is invalid without title' do
      lesson = Lesson.new(course: course, order_index: 1)
      expect(lesson).not_to be_valid
      expect(lesson.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without order_index' do
      lesson = Lesson.new(course: course, title: 'Test Lesson')
      expect(lesson).not_to be_valid
      expect(lesson.errors[:order_index]).to include("can't be blank")
    end

    it 'is invalid with order_index less than 1' do
      lesson = Lesson.new(course: course, title: 'Test Lesson', order_index: 0)
      expect(lesson).not_to be_valid
    end

    it 'is invalid with invalid video_url format' do
      lesson = Lesson.new(course: course, title: 'Test Lesson', order_index: 1, video_url: 'invalid-url')
      expect(lesson).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to course' do
      lesson = Lesson.create!(course: course, title: 'Test Lesson', order_index: 1)
      expect(lesson.course).to eq(course)
    end

    it 'has many session_analyses' do
      lesson = Lesson.create!(course: course, title: 'Test Lesson', order_index: 1)
      user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student')
      analysis = SessionAnalysis.create!(user: user, lesson: lesson, overall_score: 85)
      expect(lesson.session_analyses).to include(analysis)
    end
  end
end

