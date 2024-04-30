# frozen_string_literal: true

require "openai"

class ChatGptService
  def self.chat(message)
    return dummy_gpt

    client = OpenAI::Client.new(access_token: ENV["CHAT_GPT_API_KEY"])
    # https://platform.openai.com/docs/models/overview
    # Rails.logger.info(client.models.list.map(&:id))
    client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: message }],
        stream: proc do |chunk, _bytesize|
                  # ここでActionCableを使用してフロントエンドにデータを送信
                  # TODO: broadcastだと全員に送られてしまうのでここは要修正
                  Rails.logger.info("ChatGptService.chat: #{chunk.dig('choices', 0, 'delta',
                                                                      'content')}")
                  ActionCable.server.broadcast("chat_channel",
                                               chunk.dig("choices", 0, "delta", "content"))
                end,
      },
    )
  end

  def self.dummy_gpt
    Rails.logger.info("start chat")
    100.times do |i|
      ActionCable.server.broadcast("chat_channel", "感謝の正拳突き! #{i}<br>")
    end
  end
end
