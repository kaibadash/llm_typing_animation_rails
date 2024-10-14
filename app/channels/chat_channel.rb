# frozen_string_literal: true

class ChatChannel < ActionCable::Channel::Base
  def subscribed
    Rails.logger.info("subscribed: #{current_user.email}")
    stream_from "chat_channel"
    stream_for current_user
  end

  def unsubscribed
    Rails.logger.info("unsubscribed")
    # Any cleanup needed when channel is unsubscribed
  end
end
