# Soulingo Backend - Comprehensive Seed Data
# This file creates sample data for testing and development
# Run with: rails db:seed

puts "🌱 Starting seed process..."

# Clear existing data (in development only)
if Rails.env.development?
  puts "🧹 Cleaning existing data..."
  SessionAnalysis.destroy_all
  Enrollment.destroy_all
  Lesson.destroy_all
  Course.destroy_all
  User.destroy_all
  puts "✓ Existing data cleared"
end

# ============================================================================
# USERS
# ============================================================================
puts "\n👥 Creating users..."

# Admin users
admin1 = User.create!(
  email: 'admin@soulingo.com',
  password: 'admin123456',
  name: 'Admin User',
  role: 'admin',
  avatar_url: 'https://i.pravatar.cc/150?img=1'
)

admin2 = User.create!(
  email: 'teacher@soulingo.com',
  password: 'teacher123456',
  name: 'Sarah Johnson',
  role: 'admin',
  avatar_url: 'https://i.pravatar.cc/150?img=5'
)

# Student users
student1 = User.create!(
  email: 'student1@example.com',
  password: 'student123456',
  name: 'Ahmet Yılmaz',
  role: 'student',
  avatar_url: 'https://i.pravatar.cc/150?img=12'
)

student2 = User.create!(
  email: 'student2@example.com',
  password: 'student123456',
  name: 'Ayşe Demir',
  role: 'student',
  avatar_url: 'https://i.pravatar.cc/150?img=20'
)

student3 = User.create!(
  email: 'student3@example.com',
  password: 'student123456',
  name: 'Mehmet Kaya',
  role: 'student',
  avatar_url: 'https://i.pravatar.cc/150?img=33'
)

student4 = User.create!(
  email: 'student4@example.com',
  password: 'student123456',
  name: 'Fatma Şahin',
  role: 'student',
  avatar_url: 'https://i.pravatar.cc/150?img=45'
)

student5 = User.create!(
  email: 'john.doe@example.com',
  password: 'password123456',
  name: 'John Doe',
  role: 'student',
  avatar_url: 'https://i.pravatar.cc/150?img=68'
)

puts "✓ Created #{User.count} users (#{User.where(role: 'admin').count} admins, #{User.where(role: 'student').count} students)"

# ============================================================================
# COURSES
# ============================================================================
puts "\n📚 Creating courses..."

# English Courses
english_a1 = Course.create!(
  title: 'English for Beginners (A1)',
  language_code: 'en',
  level: 'A1',
  description: 'Start your English journey! Learn basic greetings, introductions, and everyday phrases. Perfect for absolute beginners.',
  is_published: true
)

english_a2 = Course.create!(
  title: 'Elementary English (A2)',
  language_code: 'en',
  level: 'A2',
  description: 'Build on your basics! Expand your vocabulary and learn to have simple conversations about familiar topics.',
  is_published: true
)

english_b1 = Course.create!(
  title: 'Intermediate English (B1)',
  language_code: 'en',
  level: 'B1',
  description: 'Take your English to the next level! Learn to express opinions, describe experiences, and handle most travel situations.',
  is_published: true
)

english_b2 = Course.create!(
  title: 'Upper-Intermediate English (B2)',
  language_code: 'en',
  level: 'B2',
  description: 'Master complex topics! Develop fluency in discussions, understand detailed texts, and express yourself spontaneously.',
  is_published: true
)

# Turkish Courses
turkish_a1 = Course.create!(
  title: 'Yeni Başlayanlar için Türkçe (A1)',
  language_code: 'tr',
  level: 'A1',
  description: 'Türkçe öğrenmeye başlayın! Temel selamlaşmalar, tanışmalar ve günlük ifadeleri öğrenin.',
  is_published: true
)

turkish_a2 = Course.create!(
  title: 'Temel Türkçe (A2)',
  language_code: 'tr',
  level: 'A2',
  description: 'Türkçe bilginizi geliştirin! Kelime dağarcığınızı genişletin ve tanıdık konularda basit konuşmalar yapın.',
  is_published: true
)

turkish_b1 = Course.create!(
  title: 'Orta Seviye Türkçe (B1)',
  language_code: 'tr',
  level: 'B1',
  description: 'Türkçenizi bir üst seviyeye taşıyın! Görüş bildirmeyi, deneyimleri anlatmayı öğrenin.',
  is_published: true
)

# Spanish Course
spanish_a1 = Course.create!(
  title: 'Spanish for Beginners (A1)',
  language_code: 'es',
  level: 'A1',
  description: '¡Hola! Start learning Spanish from scratch. Master basic greetings, numbers, and essential phrases.',
  is_published: true
)

# Unpublished course for testing
unpublished_course = Course.create!(
  title: 'Advanced Business English (C1)',
  language_code: 'en',
  level: 'C1',
  description: 'Professional English for business contexts. Coming soon!',
  is_published: false
)

puts "✓ Created #{Course.count} courses (#{Course.where(is_published: true).count} published)"

# ============================================================================
# LESSONS
# ============================================================================
puts "\n📖 Creating lessons..."

# English A1 Lessons
Lesson.create!([
  {
    course: english_a1,
    title: 'Lesson 1: Greetings and Introductions',
    order_index: 1,
    description: 'Learn how to greet people and introduce yourself in English.',
    video_url: 'https://example.com/videos/en-a1-lesson1.mp4',
    expected_duration_minutes: 25
  },
  {
    course: english_a1,
    title: 'Lesson 2: Numbers and Counting',
    order_index: 2,
    description: 'Master numbers from 1 to 100 and learn to count in English.',
    video_url: 'https://example.com/videos/en-a1-lesson2.mp4',
    expected_duration_minutes: 30
  },
  {
    course: english_a1,
    title: 'Lesson 3: Colors and Shapes',
    order_index: 3,
    description: 'Discover colors and basic shapes in English.',
    video_url: 'https://example.com/videos/en-a1-lesson3.mp4',
    expected_duration_minutes: 20
  },
  {
    course: english_a1,
    title: 'Lesson 4: Family Members',
    order_index: 4,
    description: 'Learn vocabulary for family relationships.',
    video_url: 'https://example.com/videos/en-a1-lesson4.mp4',
    expected_duration_minutes: 28
  },
  {
    course: english_a1,
    title: 'Lesson 5: Daily Routines',
    order_index: 5,
    description: 'Talk about your daily activities and routines.',
    video_url: 'https://example.com/videos/en-a1-lesson5.mp4',
    expected_duration_minutes: 35
  }
])

# English A2 Lessons
Lesson.create!([
  {
    course: english_a2,
    title: 'Lesson 1: Shopping and Money',
    order_index: 1,
    description: 'Learn how to shop and handle money in English.',
    video_url: 'https://example.com/videos/en-a2-lesson1.mp4',
    expected_duration_minutes: 30
  },
  {
    course: english_a2,
    title: 'Lesson 2: Food and Restaurants',
    order_index: 2,
    description: 'Order food and talk about your favorite dishes.',
    video_url: 'https://example.com/videos/en-a2-lesson2.mp4',
    expected_duration_minutes: 32
  },
  {
    course: english_a2,
    title: 'Lesson 3: Travel and Transportation',
    order_index: 3,
    description: 'Navigate transportation and plan trips.',
    video_url: 'https://example.com/videos/en-a2-lesson3.mp4',
    expected_duration_minutes: 28
  }
])

# English B1 Lessons
Lesson.create!([
  {
    course: english_b1,
    title: 'Lesson 1: Expressing Opinions',
    order_index: 1,
    description: 'Learn to express and defend your opinions.',
    video_url: 'https://example.com/videos/en-b1-lesson1.mp4',
    expected_duration_minutes: 40
  },
  {
    course: english_b1,
    title: 'Lesson 2: Past Experiences',
    order_index: 2,
    description: 'Talk about past events and experiences.',
    video_url: 'https://example.com/videos/en-b1-lesson2.mp4',
    expected_duration_minutes: 38
  },
  {
    course: english_b1,
    title: 'Lesson 3: Making Plans',
    order_index: 3,
    description: 'Discuss future plans and arrangements.',
    video_url: 'https://example.com/videos/en-b1-lesson3.mp4',
    expected_duration_minutes: 35
  },
  {
    course: english_b1,
    title: 'Lesson 4: Problem Solving',
    order_index: 4,
    description: 'Learn to discuss problems and suggest solutions.',
    video_url: 'https://example.com/videos/en-b1-lesson4.mp4',
    expected_duration_minutes: 42
  }
])

# English B2 Lessons
Lesson.create!([
  {
    course: english_b2,
    title: 'Lesson 1: Advanced Discussions',
    order_index: 1,
    description: 'Engage in complex discussions on various topics.',
    video_url: 'https://example.com/videos/en-b2-lesson1.mp4',
    expected_duration_minutes: 45
  },
  {
    course: english_b2,
    title: 'Lesson 2: Academic Writing',
    order_index: 2,
    description: 'Master formal writing and essay structure.',
    video_url: 'https://example.com/videos/en-b2-lesson2.mp4',
    expected_duration_minutes: 50
  }
])

# Turkish A1 Lessons
Lesson.create!([
  {
    course: turkish_a1,
    title: 'Ders 1: Selamlaşma ve Tanışma',
    order_index: 1,
    description: 'Türkçede nasıl selamlaşılır ve tanışılır öğrenin.',
    video_url: 'https://example.com/videos/tr-a1-lesson1.mp4',
    expected_duration_minutes: 25
  },
  {
    course: turkish_a1,
    title: 'Ders 2: Sayılar ve Saymak',
    order_index: 2,
    description: '1\'den 100\'e kadar sayıları öğrenin.',
    video_url: 'https://example.com/videos/tr-a1-lesson2.mp4',
    expected_duration_minutes: 30
  },
  {
    course: turkish_a1,
    title: 'Ders 3: Renkler ve Şekiller',
    order_index: 3,
    description: 'Renkleri ve temel şekilleri keşfedin.',
    video_url: 'https://example.com/videos/tr-a1-lesson3.mp4',
    expected_duration_minutes: 22
  }
])

# Turkish A2 Lessons
Lesson.create!([
  {
    course: turkish_a2,
    title: 'Ders 1: Alışveriş',
    order_index: 1,
    description: 'Türkçede alışveriş yapmayı öğrenin.',
    video_url: 'https://example.com/videos/tr-a2-lesson1.mp4',
    expected_duration_minutes: 28
  },
  {
    course: turkish_a2,
    title: 'Ders 2: Yemek ve Restoran',
    order_index: 2,
    description: 'Restoranda yemek sipariş etmeyi öğrenin.',
    video_url: 'https://example.com/videos/tr-a2-lesson2.mp4',
    expected_duration_minutes: 30
  }
])

# Spanish A1 Lessons
Lesson.create!([
  {
    course: spanish_a1,
    title: 'Lección 1: Saludos y Presentaciones',
    order_index: 1,
    description: 'Aprende a saludar y presentarte en español.',
    video_url: 'https://example.com/videos/es-a1-lesson1.mp4',
    expected_duration_minutes: 25
  },
  {
    course: spanish_a1,
    title: 'Lección 2: Números',
    order_index: 2,
    description: 'Domina los números del 1 al 100.',
    video_url: 'https://example.com/videos/es-a1-lesson2.mp4',
    expected_duration_minutes: 28
  }
])

puts "✓ Created #{Lesson.count} lessons across all courses"

# ============================================================================
# ENROLLMENTS
# ============================================================================
puts "\n🎓 Creating enrollments..."

# Student 1 (Ahmet) - Active learner, enrolled in multiple courses
Enrollment.create!([
  {
    user: student1,
    course: english_a1,
    status: 'completed',
    progress_percent: 100,
    started_at: 3.months.ago,
    completed_at: 2.months.ago
  },
  {
    user: student1,
    course: english_a2,
    status: 'active',
    progress_percent: 65,
    started_at: 2.months.ago,
    completed_at: nil
  },
  {
    user: student1,
    course: turkish_a1,
    status: 'active',
    progress_percent: 30,
    started_at: 1.month.ago,
    completed_at: nil
  }
])

# Student 2 (Ayşe) - Beginner, just started
Enrollment.create!([
  {
    user: student2,
    course: english_a1,
    status: 'active',
    progress_percent: 40,
    started_at: 1.month.ago,
    completed_at: nil
  },
  {
    user: student2,
    course: spanish_a1,
    status: 'active',
    progress_percent: 20,
    started_at: 2.weeks.ago,
    completed_at: nil
  }
])

# Student 3 (Mehmet) - Advanced learner
Enrollment.create!([
  {
    user: student3,
    course: english_a1,
    status: 'completed',
    progress_percent: 100,
    started_at: 6.months.ago,
    completed_at: 5.months.ago
  },
  {
    user: student3,
    course: english_a2,
    status: 'completed',
    progress_percent: 100,
    started_at: 5.months.ago,
    completed_at: 3.months.ago
  },
  {
    user: student3,
    course: english_b1,
    status: 'active',
    progress_percent: 75,
    started_at: 3.months.ago,
    completed_at: nil
  },
  {
    user: student3,
    course: english_b2,
    status: 'active',
    progress_percent: 25,
    started_at: 1.month.ago,
    completed_at: nil
  }
])

# Student 4 (Fatma) - Dropped one course
Enrollment.create!([
  {
    user: student4,
    course: english_a1,
    status: 'active',
    progress_percent: 80,
    started_at: 2.months.ago,
    completed_at: nil
  },
  {
    user: student4,
    course: turkish_a2,
    status: 'dropped',
    progress_percent: 15,
    started_at: 3.months.ago,
    completed_at: nil
  }
])

# Student 5 (John) - New student
Enrollment.create!([
  {
    user: student5,
    course: turkish_a1,
    status: 'active',
    progress_percent: 10,
    started_at: 1.week.ago,
    completed_at: nil
  }
])

puts "✓ Created #{Enrollment.count} enrollments"
puts "  - Active: #{Enrollment.where(status: 'active').count}"
puts "  - Completed: #{Enrollment.where(status: 'completed').count}"
puts "  - Dropped: #{Enrollment.where(status: 'dropped').count}"

# ============================================================================
# SESSION ANALYSES
# ============================================================================
puts "\n📊 Creating session analyses..."

# Get lessons for creating session analyses
en_a1_lessons = english_a1.lessons.order(:order_index)
en_a2_lessons = english_a2.lessons.order(:order_index)
en_b1_lessons = english_b1.lessons.order(:order_index)
tr_a1_lessons = turkish_a1.lessons.order(:order_index)
es_a1_lessons = spanish_a1.lessons.order(:order_index)

# Student 1 (Ahmet) - Completed English A1, working on A2
# English A1 sessions (all lessons completed)
en_a1_lessons.each_with_index do |lesson, index|
  SessionAnalysis.create!(
    user: student1,
    lesson: lesson,
    overall_score: 75 + rand(20),
    fluency_score: 70 + rand(25),
    grammar_score: 75 + rand(20),
    pronunciation_score: 72 + rand(23),
    feedback_text: "İyi bir performans gösterdiniz. #{['Akıcılığınızı geliştirmeye devam edin.', 'Gramer bilginiz güçleniyor.', 'Telaffuzunuz gelişiyor.'].sample}",
    recorded_video_url: "https://example.com/sessions/student1-en-a1-lesson#{index + 1}.mp4",
    raw_transcript: "Hello, my name is Ahmet. I am learning English. #{['I like to study every day.', 'English is interesting.', 'I practice speaking.'].sample}",
    session_started_at: (3.months.ago + index.weeks),
    session_ended_at: (3.months.ago + index.weeks + 30.minutes)
  )
end

# English A2 sessions (partial progress)
en_a2_lessons.first(2).each_with_index do |lesson, index|
  SessionAnalysis.create!(
    user: student1,
    lesson: lesson,
    overall_score: 80 + rand(15),
    fluency_score: 78 + rand(18),
    grammar_score: 82 + rand(15),
    pronunciation_score: 79 + rand(17),
    feedback_text: "Harika ilerleme! #{['Kelime dağarcığınız genişliyor.', 'Cümle yapılarını iyi kullanıyorsunuz.', 'Özgüveniniz artıyor.'].sample}",
    recorded_video_url: "https://example.com/sessions/student1-en-a2-lesson#{index + 1}.mp4",
    raw_transcript: "I went shopping yesterday. I bought some fruits and vegetables. #{['The weather was nice.', 'I met my friend.', 'It was a good day.'].sample}",
    session_started_at: (2.months.ago + index.weeks),
    session_ended_at: (2.months.ago + index.weeks + 35.minutes)
  )
end

# Turkish A1 sessions (just started)
tr_a1_lessons.first(1).each do |lesson|
  SessionAnalysis.create!(
    user: student1,
    lesson: lesson,
    overall_score: 65,
    fluency_score: 60,
    grammar_score: 68,
    pronunciation_score: 67,
    feedback_text: "İyi bir başlangıç! Türkçe öğrenmeye devam edin.",
    recorded_video_url: "https://example.com/sessions/student1-tr-a1-lesson1.mp4",
    raw_transcript: "Merhaba, benim adım Ahmet. Türkçe öğreniyorum.",
    session_started_at: 1.month.ago,
    session_ended_at: 1.month.ago + 28.minutes
  )
end

# Student 2 (Ayşe) - Working on English A1
en_a1_lessons.first(2).each_with_index do |lesson, index|
  SessionAnalysis.create!(
    user: student2,
    lesson: lesson,
    overall_score: 70 + rand(15),
    fluency_score: 68 + rand(17),
    grammar_score: 72 + rand(14),
    pronunciation_score: 70 + rand(16),
    feedback_text: "Güzel bir performans. #{['Pratik yapmaya devam edin.', 'Dinleme becerileriniz gelişiyor.', 'Konuşma pratiği yapın.'].sample}",
    recorded_video_url: "https://example.com/sessions/student2-en-a1-lesson#{index + 1}.mp4",
    raw_transcript: "Hello, I am Ayşe. Nice to meet you. #{['How are you?', 'I am fine, thank you.', 'What is your name?'].sample}",
    session_started_at: (1.month.ago + index.weeks),
    session_ended_at: (1.month.ago + index.weeks + 25.minutes)
  )
end

# Spanish A1 session
es_a1_lessons.first(1).each do |lesson|
  SessionAnalysis.create!(
    user: student2,
    lesson: lesson,
    overall_score: 62,
    fluency_score: 58,
    grammar_score: 65,
    pronunciation_score: 63,
    feedback_text: "İspanyolca öğrenmeye iyi bir başlangıç yaptınız!",
    recorded_video_url: "https://example.com/sessions/student2-es-a1-lesson1.mp4",
    raw_transcript: "Hola, me llamo Ayşe. Mucho gusto.",
    session_started_at: 2.weeks.ago,
    session_ended_at: 2.weeks.ago + 22.minutes
  )
end

# Student 3 (Mehmet) - Advanced learner with many sessions
# English B1 sessions (current course)
en_b1_lessons.each_with_index do |lesson, index|
  SessionAnalysis.create!(
    user: student3,
    lesson: lesson,
    overall_score: 85 + rand(12),
    fluency_score: 83 + rand(14),
    grammar_score: 87 + rand(10),
    pronunciation_score: 85 + rand(12),
    feedback_text: "Mükemmel performans! #{['İleri seviyeye hazırsınız.', 'Akıcılığınız çok iyi.', 'Gramer kullanımınız harika.'].sample}",
    recorded_video_url: "https://example.com/sessions/student3-en-b1-lesson#{index + 1}.mp4",
    raw_transcript: "In my opinion, learning languages is very important. I think it helps us understand different cultures. #{['I enjoy practicing every day.', 'It opens new opportunities.', 'Communication is key.'].sample}",
    session_started_at: (3.months.ago + index.weeks),
    session_ended_at: (3.months.ago + index.weeks + 40.minutes)
  )
end

# Student 4 (Fatma) - Working on English A1
en_a1_lessons.first(4).each_with_index do |lesson, index|
  SessionAnalysis.create!(
    user: student4,
    lesson: lesson,
    overall_score: 73 + rand(17),
    fluency_score: 71 + rand(19),
    grammar_score: 75 + rand(16),
    pronunciation_score: 73 + rand(18),
    feedback_text: "Başarılı bir çalışma. #{['Devam edin!', 'Gelişiminiz görülüyor.', 'Pratik önemli.'].sample}",
    recorded_video_url: "https://example.com/sessions/student4-en-a1-lesson#{index + 1}.mp4",
    raw_transcript: "My name is Fatma. I have a family. #{['I have two brothers.', 'My mother is a teacher.', 'We live in Istanbul.'].sample}",
    session_started_at: (2.months.ago + index.weeks),
    session_ended_at: (2.months.ago + index.weeks + 27.minutes)
  )
end

# Student 5 (John) - Just started Turkish
tr_a1_lessons.first(1).each do |lesson|
  SessionAnalysis.create!(
    user: student5,
    lesson: lesson,
    overall_score: 55,
    fluency_score: 50,
    grammar_score: 58,
    pronunciation_score: 57,
    feedback_text: "Türkçe öğrenmeye başladınız. Pratik yaparak gelişeceksiniz!",
    recorded_video_url: "https://example.com/sessions/student5-tr-a1-lesson1.mp4",
    raw_transcript: "Merhaba. Ben John. Türkçe öğreniyorum.",
    session_started_at: 1.week.ago,
    session_ended_at: 1.week.ago + 20.minutes
  )
end

puts "✓ Created #{SessionAnalysis.count} session analyses"

# ============================================================================
# SUMMARY
# ============================================================================
puts "\n" + "="*60
puts "🎉 Seed data created successfully!"
puts "="*60
puts "\n📊 Summary:"
puts "  👥 Users: #{User.count} (#{User.where(role: 'admin').count} admins, #{User.where(role: 'student').count} students)"
puts "  📚 Courses: #{Course.count} (#{Course.where(is_published: true).count} published)"
puts "  📖 Lessons: #{Lesson.count}"
puts "  🎓 Enrollments: #{Enrollment.count}"
puts "  📊 Session Analyses: #{SessionAnalysis.count}"
puts "\n🔑 Test Credentials:"
puts "  Admin: admin@soulingo.com / admin123456"
puts "  Teacher: teacher@soulingo.com / teacher123456"
puts "  Student 1: student1@example.com / student123456"
puts "  Student 2: student2@example.com / student123456"
puts "  Student 3: student3@example.com / student123456"
puts "  Student 4: student4@example.com / student123456"
puts "  Student 5: john.doe@example.com / password123456"
puts "\n✅ Ready for testing!"
puts "="*60
