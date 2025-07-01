class Question < ApplicationRecord
  belongs_to :user

  after_create :fetch_ai_answer

  def fetch_ai_answer
    return if processing?  # Rails auto-defines `processing?` if you have a boolean column named `processing`
    update(processing: true)
    ChatbotJob.perform_later(self)
  end
end
