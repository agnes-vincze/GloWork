class Question < ApplicationRecord
  belongs_to :user

  after_create :fetch_ai_answer

  def fetch_ai_answer
    return if processing?  # prevent enqueueing if already processing
    ChatbotJob.perform_later(self)
    update(processing: true)
  end

  def processing?
    processing
  end
end
