require 'rails_helper'

RSpec.describe SessionAnalysis, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student') }
  let(:course) { Course.create!(title: 'Test Course', language_code: 'en', level: 'A1', is_published: true) }
  let(:lesson) { Lesson.create!(course: course, title: 'Test Lesson', order_index: 1) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      analysis = SessionAnalysis.new(
        user: user,
        lesson: lesson,
        overall_score: 85,
        fluency_score: 80,
        grammar_score: 90,
        pronunciation_score: 85
      )
      expect(analysis).to be_valid
    end

    it 'is invalid without user_id' do
      analysis = SessionAnalysis.new(lesson: lesson, overall_score: 85)
      expect(analysis).not_to be_valid
    end

    it 'is invalid without lesson_id' do
      analysis = SessionAnalysis.new(user: user, overall_score: 85)
      expect(analysis).not_to be_valid
    end

    it 'is invalid with overall_score less than 0' do
      analysis = SessionAnalysis.new(user: user, lesson: lesson, overall_score: -1)
      expect(analysis).not_to be_valid
    end

    it 'is invalid with overall_score greater than 100' do
      analysis = SessionAnalysis.new(user: user, lesson: lesson, overall_score: 101)
      expect(analysis).not_to be_valid
    end

    it 'allows nil scores' do
      analysis = SessionAnalysis.new(user: user, lesson: lesson)
      expect(analysis).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      analysis = SessionAnalysis.create!(user: user, lesson: lesson, overall_score: 85)
      expect(analysis.user).to eq(user)
    end

    it 'belongs to lesson' do
      analysis = SessionAnalysis.create!(user: user, lesson: lesson, overall_score: 85)
      expect(analysis.lesson).to eq(lesson)
    end
  end
end

