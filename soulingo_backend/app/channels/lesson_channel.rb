class LessonChannel < ApplicationCable::Channel
  def subscribed
    lesson_id = params[:lesson_id]
    
    # Lesson'ın var olduğunu kontrol et
    lesson = Lesson.find_by(id: lesson_id)
    if lesson.nil?
      reject
      return
    end

    # Channel'a subscribe ol
    stream_from "lesson_#{lesson_id}"
    
    # Session başladı mesajı gönder
    broadcast_to_lesson(lesson_id, {
      type: "session_start",
      message: "Session started",
      timestamp: Time.current.iso8601,
      lesson_id: lesson_id
    })
  end

  def unsubscribed
    # Session bitti mesajı gönder
    lesson_id = params[:lesson_id]
    if lesson_id
      broadcast_to_lesson(lesson_id, {
        type: "session_end",
        message: "Session ended",
        timestamp: Time.current.iso8601,
        lesson_id: lesson_id
      })
    end
  end

  def receive(data)
    # Client'tan gelen mesajı işle
    case data['type']
    when 'user_message'
      handle_user_message(data)
    when 'end_session'
      handle_end_session(data)
    else
      # Bilinmeyen mesaj tipi
      transmit({
        type: "error",
        message: "Unknown message type: #{data['type']}",
        timestamp: Time.current.iso8601
      })
    end
  end

  private

  def handle_user_message(data)
    lesson_id = params[:lesson_id]
    content = data['content']
    conversation_id = data['conversation_id'] || SecureRandom.uuid

    # Ai::ConversationClient kullanarak response oluştur
    # Şu anlık stub implementation kullanılıyor
    response = Ai::ConversationClient.generate_response(
      user_id: current_user.id,
      lesson_id: lesson_id.to_i,
      message_history: [] # Gelecekte conversation history eklenecek
    )

    # AI mesajını broadcast et
    broadcast_to_lesson(lesson_id, {
      type: "ai_message",
      content: response[:response_text],
      timestamp: Time.current.iso8601,
      conversation_id: conversation_id,
      partial: false,
      confidence: response[:confidence],
      suggestions: response[:suggestions]
    })
  end

  def handle_end_session(data)
    lesson_id = params[:lesson_id]
    
    # SessionAnalysis oluşturulması için manuel API çağrısı gerekiyor
    # Burada sadece session_end mesajı gönderiyoruz
    broadcast_to_lesson(lesson_id, {
      type: "session_end",
      message: "Session ended by user",
      timestamp: Time.current.iso8601,
      lesson_id: lesson_id
    })
  end


  def broadcast_to_lesson(lesson_id, message)
    ActionCable.server.broadcast("lesson_#{lesson_id}", message)
  end
end

