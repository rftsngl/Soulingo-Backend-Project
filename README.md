# Soulingo Backend API

A comprehensive RESTful API backend for a language learning platform built with Ruby on Rails 8.0 and PostgreSQL. This API provides authentication, course management, lesson tracking, enrollment handling, and AI-powered session analysis features.

## 📋 Table of Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Features](#features)
- [API Endpoints](#api-endpoints)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Database Seeding](#database-seeding)
- [API Testing](#api-testing)
- [Project Structure](#project-structure)
- [Development](#development)

## 🎯 Overview

Soulingo Backend API is a modern, scalable backend service designed for language learning applications. It enables users to:

- Register and authenticate securely using JWT tokens
- Browse and enroll in language courses (English, Turkish, German, French, Spanish, etc.)
- Access structured lessons with video content
- Track learning progress and completion status
- Receive AI-powered feedback on speaking practice sessions
- Analyze performance metrics (fluency, grammar, pronunciation)

The API follows RESTful principles and uses JSON:API specification for consistent response formatting.

## 🛠 Technology Stack

- **Framework**: Ruby on Rails 8.0.0
- **Language**: Ruby 3.2.9
- **Database**: PostgreSQL
- **Web Server**: Puma
- **Authentication**: JWT (JSON Web Tokens)
- **Password Hashing**: BCrypt
- **Serialization**: Active Model Serializers
- **Background Jobs**: Sidekiq
- **Caching**: Redis, Solid Cache
- **Queue**: Solid Queue
- **Cable**: Solid Cable (WebSocket support)
- **CORS**: Rack CORS
- **Testing**: RSpec
- **Code Quality**: RuboCop, Brakeman

## ✨ Features

### Authentication & Authorization
- User registration with email and password
- Secure JWT-based authentication
- Role-based access control (Student, Admin)
- Password encryption using BCrypt

### Course Management
- Create, read, update, and delete courses (Admin only)
- Multi-language support (language_code field)
- CEFR level classification (A1, A2, B1, B2, C1, C2)
- Course publishing status control
- Public course listing and details

### Lesson Management
- Structured lessons within courses
- Ordered lesson sequences (order_index)
- Video content URLs
- Expected duration tracking
- Admin-only lesson management

### Enrollment System
- User course enrollment
- Progress tracking (0-100%)
- Enrollment status (active, completed, dropped)
- Start and completion timestamps
- User course history

### Session Analysis
- AI-powered speaking session analysis
- Multi-dimensional scoring:
  - Overall score
  - Fluency score
  - Grammar score
  - Pronunciation score
- Detailed feedback text
- Video recording URLs
- Raw transcript storage
- Session timing (start/end timestamps)

## 🔌 API Endpoints

### Authentication (`/v1/auth`)
- `POST /v1/auth/register` - Register a new user
- `POST /v1/auth/login` - Login and receive JWT token
- `GET /v1/auth/me` - Get current authenticated user

### Courses (`/v1/courses`)
- `GET /v1/courses` - List all published courses
- `GET /v1/courses/:id` - Get course details
- `POST /v1/courses` - Create a new course (Admin)
- `PATCH /v1/courses/:id` - Update a course (Admin)
- `DELETE /v1/courses/:id` - Delete a course (Admin)
- `POST /v1/courses/:id/enroll` - Enroll in a course
- `GET /v1/courses/:id/students` - Get course students (Admin)

### Lessons (`/v1/lessons`)
- `GET /v1/courses/:course_id/lessons` - List course lessons
- `POST /v1/courses/:course_id/lessons` - Create a lesson (Admin)
- `GET /v1/lessons/:id` - Get lesson details
- `PATCH /v1/lessons/:id` - Update a lesson (Admin)
- `DELETE /v1/lessons/:id` - Delete a lesson (Admin)

### Enrollments
- `GET /v1/users/:id/courses` - Get user's enrolled courses

### Session Analyses (`/v1/session_analyses`)
- `POST /v1/lessons/:lesson_id/session_analyses` - Create session analysis
- `GET /v1/users/:id/session_analyses` - Get user's session analyses
- `GET /v1/lessons/:id/session_analyses` - Get lesson's session analyses

## 📦 Prerequisites

Before setting up the project, ensure you have the following installed:

- **Ruby**: Version 3.2.9 or higher
  - Install via [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/)
- **PostgreSQL**: Version 9.3 or higher
  - Download from [postgresql.org](https://www.postgresql.org/download/)
- **Redis**: Version 5.0 or higher (for Sidekiq and caching)
  - Download from [redis.io](https://redis.io/download)
- **Bundler**: Ruby gem manager
  ```bash
  gem install bundler
  ```

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Proje_3/soulingo_backend
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Configure Database

The default database configuration uses:
- **Username**: `postgres`
- **Password**: `postgres`
- **Host**: `localhost`
- **Port**: `5432`

If your PostgreSQL setup differs, update `config/database.yml`:

```yaml
development:
  adapter: postgresql
  database: soulingo_backend_development
  username: your_username
  password: your_password
  host: localhost
  port: 5432
```

### 4. Create and Setup Database

```bash
rails db:create
rails db:migrate
```

### 5. Environment Configuration (Optional)

For production deployment, set the following environment variables:

```bash
export SOULINGO_BACKEND_DATABASE_PASSWORD=your_production_password
export RAILS_ENV=production
export SECRET_KEY_BASE=$(rails secret)
```

## 🏃 Running the Application

### Start the Rails Server

```bash
# Development mode (default port 3000)
rails server

# Or using the bin script
bin/rails server

# Specify a different port
rails server -p 3001
```

The API will be available at `http://localhost:3000`

### Start Background Services (Optional)

If using background jobs:

```bash
# Start Redis
redis-server

# Start Sidekiq
bundle exec sidekiq
```

### Health Check

Verify the application is running:

```bash
curl http://localhost:3000/up
```

Expected response: `200 OK`

## 🌱 Database Seeding

The project includes comprehensive seed data for development and testing.

### Seed the Database

To populate the database with sample data:

```bash
rails db:seed
```

**What this does:**
- Inserts sample users, courses, lessons, enrollments, and session analyses
- Creates test data for API testing and development
- Does NOT delete existing data (only adds new records)

### Seed Data Includes:

- **7 Users**:
  - 1 Admin user (`admin@soulingo.com` / `password123`)
  - 6 Student users
- **9 Courses**:
  - English (A1, B1, C1)
  - Turkish (A2, B2)
  - German (A1, B1)
  - French (A2)
  - Spanish (B1)
- **25+ Lessons**: Distributed across courses
- **13 Enrollments**: Various progress levels
- **30+ Session Analyses**: Sample performance data

### Reset Database (Development Only)

To completely reset the database (delete all data and reseed):

```bash
# Drop, create, migrate, and seed
rails db:reset
```

**What this does:**
1. Drops the database (`rails db:drop`)
2. Creates a new database (`rails db:create`)
3. Runs all migrations (`rails db:migrate`)
4. Seeds the database (`rails db:seed`)

**⚠️ Warning:** This will **DELETE ALL DATA** in your development database!

### Alternative: Reset and Seed Separately

If you want more control:

```bash

# Drop and recreate database
rails db:drop
rails db:create

# Run migrations
rails db:migrate

# Seed with sample data
rails db:seed
```

## 🧪 API Testing

### Using Postman Collection

A comprehensive Postman collection is included for API testing.

#### 1. Import the Collection

1. Open Postman
2. Click **Import**
3. Select `soulingo_backend/soulingo-backend.postman_collection.json`
4. Click **Import**

#### 2. Set Up Environment Variables

Create a new Postman environment with:

| Variable | Initial Value | Description |
|----------|---------------|-------------|
| `base_url` | `http://localhost:3000` | API base URL |
| `auth_token` | (empty) | Auto-populated after login |
| `user_id` | (empty) | Auto-populated after login |
| `course_id` | (empty) | Auto-populated after course creation |
| `lesson_id` | (empty) | Auto-populated after lesson creation |
| `enrollment_id` | (empty) | Auto-populated after enrollment |
| `session_analysis_id` | (empty) | Auto-populated after session creation |

#### 3. Run the Collection

The collection includes 19 endpoints organized in 6 folders:

1. **Auth** (3 endpoints)
   - Register, Login, Get Current User
2. **Courses** (4 endpoints)
   - List, Get, Create, Update
3. **Lessons** (4 endpoints)
   - List, Create, Get, Update
4. **Enrollments** (3 endpoints)
   - Enroll, Get User Courses, Get Course Students
5. **SessionAnalyses** (3 endpoints)
   - Create, Get User Analyses, Get Lesson Analyses
6. **Cleanup** (2 endpoints)
   - Delete Lesson, Delete Course

**Run Order**: Execute folders sequentially (Auth → Courses → Lessons → Enrollments → SessionAnalyses → Cleanup)

#### 4. Test Results

All 19 endpoints include comprehensive test scripts that validate:
- HTTP status codes
- Response structure (JSON:API format)
- Data types and formats
- Business logic rules
- Required vs optional fields

Expected result: **75/75 tests passing (100% success rate)**

## 📁 Project Structure

```
soulingo_backend/
├── app/
│   ├── controllers/        # API controllers
│   │   └── v1/            # API version 1
│   ├── models/            # ActiveRecord models
│   ├── serializers/       # JSON:API serializers
│   └── services/          # Business logic services
├── config/
│   ├── database.yml       # Database configuration
│   ├── routes.rb          # API routes
│   └── initializers/      # App initialization
├── db/
│   ├── migrate/           # Database migrations
│   ├── schema.rb          # Current database schema
│   └── seeds.rb           # Seed data
├── spec/                  # RSpec tests
├── Gemfile                # Ruby dependencies
└── soulingo-backend.postman_collection.json  # API tests
```

## 👨‍💻 Development

### Running Tests

```bash
# Run all RSpec tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

### Code Quality

```bash
# Run RuboCop linter
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a

# Security audit
bundle exec brakeman
```

### Database Management

```bash
# Create a new migration
rails generate migration AddFieldToModel field:type

# Run pending migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Check migration status
rails db:migrate:status
```

### Console Access

```bash
# Open Rails console
rails console

# Example queries
User.count
Course.where(is_published: true)
Enrollment.includes(:user, :course).all
```

## 📄 License

This project is part of an academic assignment for the Fall 2025-2026 Multimedia course.

## 🤝 Contributing

This is an academic project. For questions or issues, please contact the project maintainer.

---

**Built with ❤️ using Ruby on Rails 8.0**
