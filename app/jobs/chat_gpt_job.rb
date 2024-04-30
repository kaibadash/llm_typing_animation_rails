class ChatGptJob < ApplicationJob
  queue_as :chat
  def perform(message)
    Rails.logger.info("ChatGptJob start: #{message}")
    ChatGptService.chat(message)
  end
end
