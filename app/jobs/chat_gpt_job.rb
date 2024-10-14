# frozen_string_literal: true

class ChatGptJob < ApplicationJob
  queue_as :chat
  def perform(user_id, message)
    Rails.logger.info("ChatGptJob start: #{message}")
    ChatGptService.chat(user_id, message)
  end
end
