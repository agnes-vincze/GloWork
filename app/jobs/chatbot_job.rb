class ChatbotJob < ApplicationJob
  queue_as :default

 def perform(question)
  @question = question
  retries ||= 0
  begin
    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai
      }
    )
    new_content = chatgpt_response["choices"][0]["message"]["content"]
    question.update(ai_answer: new_content)
    Turbo::StreamsChannel.broadcast_update_to(
      "question_#{@question.id}",
      target: "question_#{@question.id}",
      partial: "questions/question", locals: { question: question }
    )
  rescue Faraday::TooManyRequestsError => e
    retries += 1
    if retries <= 3
      sleep(2 ** retries) # exponential backoff: 2,4,8 seconds
      retry
    else
    Rails.logger.error("OpenAI rate limit exceeded: #{e.message}")
    question.update(ai_answer: "Sorry, I'm temporarily unable to answer. Please try again later.")
    end
  end
end


  private

  def client
    @client ||= OpenAI::Client.new
  end

  def questions_formatted_for_openai
    questions = @question.user.questions
    results = []
    results << { role: "system", content: "You are a friendly and professional assistant helping remote workers improve their mood and well-being at work.

    Start the conversation by saying: “Hello, how can I help you today?”

    When the user shares something, engage in conversation and be empathic. If you give tips, they should be focused, actionable, and easy to follow — avoid vague or generic advice.

   ask follow up questions. If the user says things like 'thank you' or any other phrase suggesting the end of the conversation, then politely end the conversation.

    Keep responses supportive and brief. Do not give medical or therapeutic advice." }
    questions.each do |question|
      results << { role: "user", content: question.user_question }
      results << { role: "assistant", content: question.ai_answer || "" }
    end
    return results
  end

end
