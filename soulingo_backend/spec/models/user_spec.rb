require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
        role: 'student'
      )
      expect(user).to be_valid
    end

    it 'is invalid without email' do
      user = User.new(password: 'password123', name: 'Test User', role: 'student')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with invalid email format' do
      user = User.new(email: 'invalid-email', password: 'password123', name: 'Test User', role: 'student')
      expect(user).not_to be_valid
    end

    it 'is invalid with duplicate email' do
      User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student')
      user = User.new(email: 'test@example.com', password: 'password123', name: 'Test User 2', role: 'student')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with password shorter than 8 characters' do
      user = User.new(email: 'test@example.com', password: 'short', name: 'Test User', role: 'student')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it 'is invalid without name' do
      user = User.new(email: 'test@example.com', password: 'password123', role: 'student')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with invalid role' do
      user = User.new(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'invalid')
      expect(user).not_to be_valid
      expect(user.errors[:role]).to be_present
    end

    it 'defaults to student role' do
      user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User')
      expect(user.role).to eq('student')
    end
  end

  describe 'associations' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student') }
    let(:course) { Course.create!(title: 'Test Course', language_code: 'en', level: 'A1', is_published: true) }

    it 'has many enrollments' do
      enrollment = Enrollment.create!(user: user, course: course, status: 'active')
      expect(user.enrollments).to include(enrollment)
    end

    it 'has many courses through enrollments' do
      Enrollment.create!(user: user, course: course, status: 'active')
      expect(user.courses).to include(course)
    end

    it 'has many session_analyses' do
      lesson = Lesson.create!(course: course, title: 'Test Lesson', order_index: 1)
      analysis = SessionAnalysis.create!(
        user: user,
        lesson: lesson,
        overall_score: 85
      )
      expect(user.session_analyses).to include(analysis)
    end
  end

  describe 'password hashing' do
    it 'hashes password' do
      user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student')
      expect(user.password_digest).not_to eq('password123')
      expect(user.password_digest).to be_present
    end

    it 'authenticates with correct password' do
      user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student')
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student')
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
end

