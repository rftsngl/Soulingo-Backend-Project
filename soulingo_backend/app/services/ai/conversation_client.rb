module Ai
  class ConversationClient
    # Stub implementation - gelecekte gerçek LLM servisine bağlanacak
    
    # Girdi:
    # - user_id (integer)
    # - lesson_id (integer)
    # - message_history (array of messages)
    #
    # Çıktı:
    # - response_text (string)
    # - confidence (float, optional)
    # - suggestions (array, optional)
    def self.generate_response(user_id:, lesson_id:, message_history: [])
      # Stub: Dummy response döner
      {
        response_text: "Teşekkürler, mesajını aldım. Bu bir stub response'dur.",
        confidence: 0.85,
        suggestions: [
          "Daha fazla pratik yapabilirsiniz",
          "Kelime dağarcığınızı genişletebilirsiniz"
        ]
      }
    end

    # Streaming response için (gelecekte kullanılacak)
    def self.generate_streaming_response(user_id:, lesson_id:, message_history: [], &block)
      # Stub: Streaming response simülasyonu
      response = "Teşekkürler, mesajını aldım. Bu bir stub response'dur."
      response.chars.each do |char|
        block.call(char) if block_given?
        sleep(0.05) # Simüle edilmiş gecikme
      end
      response
    end
  end
end

