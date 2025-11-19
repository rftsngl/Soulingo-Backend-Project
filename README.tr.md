# Soulingo Backend API

Ruby on Rails 8.0 ve PostgreSQL ile geliştirilmiş, dil öğrenme platformu için kapsamlı bir RESTful API backend'i. Bu API; kimlik doğrulama, kurs yönetimi, ders takibi, kayıt işlemleri ve yapay zeka destekli oturum analizi özellikleri sunar.

## 📋 İçindekiler

- [Genel Bakış](#genel-bakış)
- [Teknoloji Yığını](#teknoloji-yığını)
- [Özellikler](#özellikler)
- [API Endpoint'leri](#api-endpointleri)
- [Ön Gereksinimler](#ön-gereksinimler)
- [Kurulum](#kurulum)
- [Uygulamayı Çalıştırma](#uygulamayı-çalıştırma)
- [Veritabanı Seed İşlemi](#veritabanı-seed-işlemi)
- [API Testi](#api-testi)
- [Proje Yapısı](#proje-yapısı)
- [Geliştirme](#geliştirme)

## 🎯 Genel Bakış

Soulingo Backend API, dil öğrenme uygulamaları için tasarlanmış modern ve ölçeklenebilir bir backend servisidir. Kullanıcılara şu imkanları sunar:

- JWT token'ları kullanarak güvenli kayıt ve kimlik doğrulama
- Dil kurslarına göz atma ve kayıt olma (İngilizce, Türkçe, Almanca, Fransızca, İspanyolca vb.)
- Video içerikli yapılandırılmış derslere erişim
- Öğrenme ilerlemesi ve tamamlanma durumunu takip etme
- Konuşma pratiği oturumları için yapay zeka destekli geri bildirim alma
- Performans metriklerini analiz etme (akıcılık, dilbilgisi, telaffuz)

API, RESTful prensipleri takip eder ve tutarlı yanıt formatlaması için JSON:API spesifikasyonunu kullanır.

## 🛠 Teknoloji Yığını

- **Framework**: Ruby on Rails 8.0.0
- **Dil**: Ruby 3.2.9
- **Veritabanı**: PostgreSQL
- **Web Sunucusu**: Puma
- **Kimlik Doğrulama**: JWT (JSON Web Tokens)
- **Şifre Hashleme**: BCrypt
- **Serileştirme**: Active Model Serializers
- **Arka Plan İşleri**: Sidekiq
- **Önbellekleme**: Redis, Solid Cache
- **Kuyruk**: Solid Queue
- **Cable**: Solid Cable (WebSocket desteği)
- **CORS**: Rack CORS
- **Test**: RSpec
- **Kod Kalitesi**: RuboCop, Brakeman

## ✨ Özellikler

### Kimlik Doğrulama ve Yetkilendirme
- E-posta ve şifre ile kullanıcı kaydı
- Güvenli JWT tabanlı kimlik doğrulama
- Rol tabanlı erişim kontrolü (Öğrenci, Admin)
- BCrypt kullanarak şifre şifreleme

### Kurs Yönetimi
- Kurs oluşturma, okuma, güncelleme ve silme (Sadece Admin)
- Çoklu dil desteği (language_code alanı)
- CEFR seviye sınıflandırması (A1, A2, B1, B2, C1, C2)
- Kurs yayınlama durumu kontrolü
- Herkese açık kurs listeleme ve detayları

### Ders Yönetimi
- Kurslar içinde yapılandırılmış dersler
- Sıralı ders dizileri (order_index)
- Video içerik URL'leri
- Beklenen süre takibi
- Sadece Admin ders yönetimi

### Kayıt Sistemi
- Kullanıcı kurs kaydı
- İlerleme takibi (0-100%)
- Kayıt durumu (aktif, tamamlandı, bırakıldı)
- Başlangıç ve tamamlanma zaman damgaları
- Kullanıcı kurs geçmişi

### Oturum Analizi
- Yapay zeka destekli konuşma oturumu analizi
- Çok boyutlu puanlama:
  - Genel puan
  - Akıcılık puanı
  - Dilbilgisi puanı
  - Telaffuz puanı
- Detaylı geri bildirim metni
- Video kayıt URL'leri
- Ham transkript depolama
- Oturum zamanlaması (başlangıç/bitiş zaman damgaları)

## 🔌 API Endpoint'leri

### Kimlik Doğrulama (`/v1/auth`)
- `POST /v1/auth/register` - Yeni kullanıcı kaydı
- `POST /v1/auth/login` - Giriş yapma ve JWT token alma
- `GET /v1/auth/me` - Mevcut kimliği doğrulanmış kullanıcıyı getir

### Kurslar (`/v1/courses`)
- `GET /v1/courses` - Tüm yayınlanmış kursları listele
- `GET /v1/courses/:id` - Kurs detaylarını getir
- `POST /v1/courses` - Yeni kurs oluştur (Admin)
- `PATCH /v1/courses/:id` - Kursu güncelle (Admin)
- `DELETE /v1/courses/:id` - Kursu sil (Admin)
- `POST /v1/courses/:id/enroll` - Kursa kayıt ol
- `GET /v1/courses/:id/students` - Kurs öğrencilerini getir (Admin)

### Dersler (`/v1/lessons`)
- `GET /v1/courses/:course_id/lessons` - Kurs derslerini listele
- `POST /v1/courses/:course_id/lessons` - Ders oluştur (Admin)
- `GET /v1/lessons/:id` - Ders detaylarını getir
- `PATCH /v1/lessons/:id` - Dersi güncelle (Admin)
- `DELETE /v1/lessons/:id` - Dersi sil (Admin)

### Kayıtlar
- `GET /v1/users/:id/courses` - Kullanıcının kayıtlı olduğu kursları getir

### Oturum Analizleri (`/v1/session_analyses`)
- `POST /v1/lessons/:lesson_id/session_analyses` - Oturum analizi oluştur
- `GET /v1/users/:id/session_analyses` - Kullanıcının oturum analizlerini getir
- `GET /v1/lessons/:id/session_analyses` - Dersin oturum analizlerini getir

## 📦 Ön Gereksinimler

Projeyi kurmadan önce, aşağıdakilerin yüklü olduğundan emin olun:

- **Ruby**: Versiyon 3.2.9 veya üzeri
  - [rbenv](https://github.com/rbenv/rbenv) veya [RVM](https://rvm.io/) ile yükleyin
- **PostgreSQL**: Versiyon 9.3 veya üzeri
  - [postgresql.org](https://www.postgresql.org/download/) adresinden indirin
- **Redis**: Versiyon 5.0 veya üzeri (Sidekiq ve önbellekleme için)
  - [redis.io](https://redis.io/download) adresinden indirin
- **Bundler**: Ruby gem yöneticisi
  ```bash
  gem install bundler
  ```

## 🚀 Kurulum

### 1. Repository'yi Klonlayın

```bash
git clone <repository-url>
cd Proje_3/soulingo_backend
```

### 2. Bağımlılıkları Yükleyin

```bash
bundle install
```

### 3. Veritabanını Yapılandırın

Varsayılan veritabanı yapılandırması şunları kullanır:
- **Kullanıcı Adı**: `postgres`
- **Şifre**: `postgres`
- **Host**: `localhost`
- **Port**: `5432`

PostgreSQL kurulumunuz farklıysa, `config/database.yml` dosyasını güncelleyin:

```yaml
development:
  adapter: postgresql
  database: soulingo_backend_development
  username: kullanici_adiniz
  password: sifreniz
  host: localhost
  port: 5432
```

### 4. Veritabanını Oluşturun ve Kurun

```bash
# Veritabanını oluştur
rails db:create

# Migration'ları çalıştır
rails db:migrate
```

### 5. Ortam Yapılandırması (Opsiyonel)

Production deployment için aşağıdaki ortam değişkenlerini ayarlayın:

```bash
export SOULINGO_BACKEND_DATABASE_PASSWORD=production_sifreniz
export RAILS_ENV=production
export SECRET_KEY_BASE=$(rails secret)
```

## 🏃 Uygulamayı Çalıştırma

### Rails Sunucusunu Başlatın

```bash
# Development modu (varsayılan port 3000)
rails server

# Veya bin script'ini kullanarak
bin/rails server

# Farklı bir port belirtin
rails server -p 3001
```

API `http://localhost:3000` adresinde erişilebilir olacaktır

### Arka Plan Servislerini Başlatın (Opsiyonel)

Arka plan işlerini kullanıyorsanız:

```bash
# Redis'i başlat
redis-server

# Sidekiq'i başlat
bundle exec sidekiq
```

### Sağlık Kontrolü

Uygulamanın çalıştığını doğrulayın:

```bash
curl http://localhost:3000/up
```

Beklenen yanıt: `200 OK`

## 🌱 Veritabanı Seed İşlemi

Proje, geliştirme ve test için kapsamlı seed verileri içerir.

### Veritabanını Seed Edin

Veritabanını örnek verilerle doldurmak için:

```bash
cd soulingo_backend
rails db:seed
```

**Bu komut ne yapar:**
- Örnek kullanıcılar, kurslar, dersler, kayıtlar ve oturum analizleri ekler
- API testi ve geliştirme için test verileri oluşturur
- Mevcut verileri SİLMEZ (sadece yeni kayıtlar ekler)

### Seed Verileri İçerir:

- **7 Kullanıcı**:
  - 1 Admin kullanıcı (`admin@soulingo.com` / `password123`)
  - 6 Öğrenci kullanıcı
- **9 Kurs**:
  - İngilizce (A1, B1, C1)
  - Türkçe (A2, B2)
  - Almanca (A1, B1)
  - Fransızca (A2)
  - İspanyolca (B1)
- **25+ Ders**: Kurslar arasında dağıtılmış
- **13 Kayıt**: Çeşitli ilerleme seviyeleri
- **30+ Oturum Analizi**: Örnek performans verileri

### Veritabanını Sıfırlama (Sadece Development)

Veritabanını tamamen sıfırlamak için (tüm verileri sil ve yeniden seed et):

```bash
cd soulingo_backend
rails db:reset
```

**Bu komut ne yapar:**
1. Veritabanını siler (`rails db:drop`)
2. Yeni veritabanı oluşturur (`rails db:create`)
3. Tüm migration'ları çalıştırır (`rails db:migrate`)
4. Veritabanını seed eder (`rails db:seed`)

**⚠️ Uyarı:** Bu komut development veritabanınızdaki **TÜM VERİLERİ SİLER!**

### Alternatif: Sıfırlama ve Seed İşlemlerini Ayrı Ayrı Yapma

Daha fazla kontrol istiyorsanız:

```bash
cd soulingo_backend

# Veritabanını sil ve yeniden oluştur
rails db:drop
rails db:create

# Migration'ları çalıştır
rails db:migrate

# Örnek verilerle doldur
rails db:seed
```

## 🧪 API Testi

### Postman Collection Kullanımı

API testi için kapsamlı bir Postman collection'ı dahil edilmiştir.

#### 1. Collection'ı İçe Aktarın

1. Postman'i açın
2. **Import**'a tıklayın
3. `soulingo_backend/soulingo-backend.postman_collection.json` dosyasını seçin
4. **Import**'a tıklayın

#### 2. Ortam Değişkenlerini Ayarlayın

Aşağıdaki değişkenlerle yeni bir Postman environment oluşturun:

| Değişken | Başlangıç Değeri | Açıklama |
|----------|------------------|----------|
| `base_url` | `http://localhost:3000` | API temel URL'i |
| `auth_token` | (boş) | Login sonrası otomatik doldurulur |
| `user_id` | (boş) | Login sonrası otomatik doldurulur |
| `course_id` | (boş) | Kurs oluşturma sonrası otomatik doldurulur |
| `lesson_id` | (boş) | Ders oluşturma sonrası otomatik doldurulur |
| `enrollment_id` | (boş) | Kayıt sonrası otomatik doldurulur |
| `session_analysis_id` | (boş) | Oturum oluşturma sonrası otomatik doldurulur |

#### 3. Collection'ı Çalıştırın

Collection, 6 klasörde düzenlenmiş 19 endpoint içerir:

1. **Auth** (3 endpoint)
   - Register, Login, Get Current User
2. **Courses** (4 endpoint)
   - List, Get, Create, Update
3. **Lessons** (4 endpoint)
   - List, Create, Get, Update
4. **Enrollments** (3 endpoint)
   - Enroll, Get User Courses, Get Course Students
5. **SessionAnalyses** (3 endpoint)
   - Create, Get User Analyses, Get Lesson Analyses
6. **Cleanup** (2 endpoint)
   - Delete Lesson, Delete Course

**Çalıştırma Sırası**: Klasörleri sırayla çalıştırın (Auth → Courses → Lessons → Enrollments → SessionAnalyses → Cleanup)

#### 4. Test Sonuçları

Tüm 19 endpoint, aşağıdakileri doğrulayan kapsamlı test scriptleri içerir:
- HTTP durum kodları
- Yanıt yapısı (JSON:API formatı)
- Veri tipleri ve formatları
- İş mantığı kuralları
- Zorunlu ve opsiyonel alanlar

Beklenen sonuç: **75/75 test başarılı (%100 başarı oranı)**

## 📁 Proje Yapısı

```
soulingo_backend/
├── app/
│   ├── controllers/        # API controller'ları
│   │   └── v1/            # API versiyon 1
│   ├── models/            # ActiveRecord modelleri
│   ├── serializers/       # JSON:API serializer'ları
│   └── services/          # İş mantığı servisleri
├── config/
│   ├── database.yml       # Veritabanı yapılandırması
│   ├── routes.rb          # API route'ları
│   └── initializers/      # Uygulama başlatma
├── db/
│   ├── migrate/           # Veritabanı migration'ları
│   ├── schema.rb          # Mevcut veritabanı şeması
│   └── seeds.rb           # Seed verileri
├── spec/                  # RSpec testleri
├── Gemfile                # Ruby bağımlılıkları
└── soulingo-backend.postman_collection.json  # API testleri
```

## 👨‍💻 Geliştirme

### Testleri Çalıştırma

```bash
# Tüm RSpec testlerini çalıştır
bundle exec rspec

# Belirli bir test dosyasını çalıştır
bundle exec rspec spec/models/user_spec.rb

# Dokümantasyon formatıyla çalıştır
bundle exec rspec --format documentation
```

### Kod Kalitesi

```bash
# RuboCop linter'ı çalıştır
bundle exec rubocop

# Sorunları otomatik düzelt
bundle exec rubocop -a

# Güvenlik denetimi
bundle exec brakeman
```

### Veritabanı Yönetimi

```bash
# Yeni bir migration oluştur
rails generate migration AddFieldToModel field:type

# Bekleyen migration'ları çalıştır
rails db:migrate

# Son migration'ı geri al
rails db:rollback

# Migration durumunu kontrol et
rails db:migrate:status
```

### Console Erişimi

```bash
# Rails console'u aç
rails console

# Örnek sorgular
User.count
Course.where(is_published: true)
Enrollment.includes(:user, :course).all
```

## 📄 Lisans

Bu proje, 2025-2026 Güz dönemi Çoklu Ortam dersi için akademik bir ödevin parçasıdır.

## 🤝 Katkıda Bulunma

Bu akademik bir projedir. Sorular veya sorunlar için lütfen proje sorumlusuyla iletişime geçin.

---

**Ruby on Rails 8.0 ile ❤️ ile geliştirilmiştir**

