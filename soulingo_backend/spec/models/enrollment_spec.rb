require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student') }
  let(:course) { Course.create!(title: 'Test Course', language_code: 'en', level: 'A1', is_published: true) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      enrollment = Enrollment.new(user: user, course: course, status: 'active', progress_percent: 0)
      expect(enrollment).to be_valid
    end

    it 'is invalid without user_id' do
      enrollment = Enrollment.new(course: course, status: 'active', progress_percent: 0)
      expect(enrollment).not_to be_valid
    end

    it 'is invalid without course_id' do
      enrollment = Enrollment.new(user: user, status: 'active', progress_percent: 0)
      expect(enrollment).not_to be_valid
    end

    it 'is invalid with invalid status' do
      enrollment = Enrollment.new(user: user, course: course, status: 'invalid', progress_percent: 0)
      expect(enrollment).not_to be_valid
      expect(enrollment.errors[:status]).to be_present
    end

    it 'is invalid with progress_percent less than 0' do
      enrollment = Enrollment.new(user: user, course: course, status: 'active', progress_percent: -1)
      expect(enrollment).not_to be_valid
    end

    it 'is invalid with progress_percent greater than 100' do
      enrollment = Enrollment.new(user: user, course: course, status: 'active', progress_percent: 101)
      expect(enrollment).not_to be_valid
    end

    it 'defaults status to active' do
      enrollment = Enrollment.create!(user: user, course: course, progress_percent: 0)
      expect(enrollment.status).to eq('active')
    end

    it 'defaults progress_percent to 0' do
      enrollment = Enrollment.create!(user: user, course: course, status: 'active')
      expect(enrollment.progress_percent).to eq(0)
    end

    it 'is invalid with duplicate user_id and course_id' do
      Enrollment.create!(user: user, course: course, status: 'active', progress_percent: 0)
      duplicate = Enrollment.new(user: user, course: course, status: 'active', progress_percent: 0)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      enrollment = Enrollment.create!(user: user, course: course, status: 'active', progress_percent: 0)
      expect(enrollment.user).to eq(user)
    end

    it 'belongs to course' do
      enrollment = Enrollment.create!(user: user, course: course, status: 'active', progress_percent: 0)
      expect(enrollment.course).to eq(course)
    end
  end
end

