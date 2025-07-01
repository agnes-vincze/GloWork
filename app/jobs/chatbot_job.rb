class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question)
    @question = question

    begin
      chatgpt_response = fetch_response_with_fallback
      new_content = chatgpt_response["choices"][0]["message"]["content"]
      question.update(ai_answer: new_content, processing: false)
    rescue => e
      Rails.logger.error("ChatbotJob failed: #{e.class} - #{e.message}")
      question.update(ai_answer: "Sorry, I'm temporarily unable to answer. Please try again later.", processing: false)
    ensure
      Turbo::StreamsChannel.broadcast_update_to(
        "question_#{question.id}",
        target: "question_#{question.id}",
        partial: "questions/question",
        locals: { question: question }
      )
    end
  end

  private

  def fetch_response_with_fallback
    begin
      client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: questions_formatted_for_openai
        }
      )
    rescue Faraday::TooManyRequestsError => e
      Rails.logger.warn("gpt-4o-mini rate limited, falling back to gpt-3.5-turbo: #{e.message}")
      client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: questions_formatted_for_openai
        }
      )
    end
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])
  end

  def questions_formatted_for_openai
    questions = @question.user.questions
    results = []
    results << {
      role: "system",
      content: "You are a friendly and professional assistant helping remote workers improve their mood and well-being at work.

Start the conversation by saying: “Hello, how can I help you today?”

When the user shares something, engage in conversation and be empathic. If you give tips, they should be focused, actionable, and easy to follow — avoid vague or generic advice.

Ask follow up questions. If the user says things like 'thank you' or any other phrase suggesting the end of the conversation, then politely end the conversation.

Keep responses supportive and brief. Do not give medical or therapeutic advice."
    }

    questions.each do |question|
      results << { role: "user", content: question.user_question }
      results << { role: "assistant", content: question.ai_answer || "" }
    end

    results
  end
end
