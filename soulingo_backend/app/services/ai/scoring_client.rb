module Ai
  class ScoringClient
    # Stub implementation - gelecekte gerçek scoring servisine bağlanacak
    
    # Girdi:
    # - raw_transcript (string)
    # - target_language (string)
    # - level (string)
    #
    # Çıktı:
    # - overall_score (integer, 0-100)
    # - fluency_score (integer, 0-100)
    # - grammar_score (integer, 0-100)
    # - pronunciation_score (integer, 0-100)
    # - feedback_text (string)
    def self.analyze_speech(raw_transcript:, target_language: 'en', level: 'A1')
      # Stub: Dummy skorlar döner
      # Gerçek implementasyonda transcript analiz edilip skorlar hesaplanacak
      
      base_score = 70 + rand(20) # 70-90 arası rastgele skor
      
      {
        overall_score: base_score,
        fluency_score: base_score + rand(-5..5),
        grammar_score: base_score + rand(-5..5),
        pronunciation_score: base_score + rand(-5..5),
        feedback_text: "İyi performans gösterdiniz. #{target_language} dilinde #{level} seviyesinde konuşma pratiği yapmaya devam edin. Daha akıcı konuşmak için düzenli pratik önemlidir."
      }
    end

    # Batch analiz için (gelecekte kullanılacak)
    def self.analyze_batch(transcripts: [], target_language: 'en', level: 'A1')
      transcripts.map do |transcript|
        analyze_speech(
          raw_transcript: transcript,
          target_language: target_language,
          level: level
        )
      end
    end
  end
end

