# frozen_string_literal: true

class ChatChannel < ActionCable::Channel::Base
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
