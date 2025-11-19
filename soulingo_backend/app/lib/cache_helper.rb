module CacheHelper
  # Cache TTL (Time To Live) - 10 dakika
  DEFAULT_TTL = 10.minutes

  # Cache key oluştur
  def self.cache_key(prefix, *args)
    key_parts = [prefix] + args.map(&:to_s)
    key_parts.join(':')
  end

  # Cache'den oku
  def self.fetch(key, ttl: DEFAULT_TTL, &block)
    Rails.cache.fetch(key, expires_in: ttl) do
      block.call if block_given?
    end
  end

  # Cache'e yaz
  def self.write(key, value, ttl: DEFAULT_TTL)
    Rails.cache.write(key, value, expires_in: ttl)
  end

  # Cache'den sil
  def self.delete(key)
    Rails.cache.delete(key)
  end

  # Pattern'e göre cache'leri sil (wildcard)
  def self.delete_matched(pattern)
    Rails.cache.delete_matched(pattern)
  end

  # Course cache key'leri
  def self.course_list_key(language_code: nil, level: nil, page: 1, per_page: 20)
    parts = ['courses', 'list']
    parts << "lang:#{language_code}" if language_code
    parts << "level:#{level}" if level
    parts << "page:#{page}"
    parts << "per_page:#{per_page}"
    cache_key(*parts)
  end

  def self.course_detail_key(course_id)
    cache_key('courses', 'detail', course_id)
  end

  # Lesson cache key'leri
  def self.lesson_list_key(course_id)
    cache_key('lessons', 'list', course_id)
  end

  def self.lesson_detail_key(lesson_id)
    cache_key('lessons', 'detail', lesson_id)
  end

  # Course cache invalidation
  def self.invalidate_course(course_id)
    # Course detail cache'ini sil
    delete(course_detail_key(course_id))
    
    # Course list cache'lerini sil (tüm filtreleme kombinasyonları)
    delete_matched('courses:list:*')
    
    # Course'un lesson list cache'ini sil
    delete(lesson_list_key(course_id))
  end

  # Lesson cache invalidation
  def self.invalidate_lesson(lesson_id, course_id = nil)
    # Lesson detail cache'ini sil
    delete(lesson_detail_key(lesson_id))
    
    # Course'un lesson list cache'ini sil
    if course_id
      delete(lesson_list_key(course_id))
    else
      # Course_id bilinmiyorsa, lesson'dan al
      lesson = Lesson.find_by(id: lesson_id)
      delete(lesson_list_key(lesson.course_id)) if lesson
    end
    
    # Course list cache'lerini de sil (lesson değiştiğinde course'lar da etkilenebilir)
    delete_matched('courses:list:*')
  end
end

