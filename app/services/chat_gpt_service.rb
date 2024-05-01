# frozen_string_literal: true

require "openai"

class ChatGptService
  def self.chat(user_id, message)
    return dummy_gpt(user_id)

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

  def self.dummy_gpt(user_id)
    current_user = User.find(user_id)
    Rails.logger.info("start send message to #{current_user.email}")
    "#{current_user.email.split("@")[0]}さん、こんにちは。これはダミーメッセージです。メッセージは以上です。".chars.each do |char|
      sleep(Random.rand(0..0.2))
      Rails.logger.info("broadcast #{char}")
      ChatChannel.broadcast_to(current_user, char)
    end
  end
end
