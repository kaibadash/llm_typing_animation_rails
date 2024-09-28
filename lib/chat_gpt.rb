# frozen_string_literal: true

require "openai"

class ChatGpt
  def self.chat(user_id, message)
    user = User.find(user_id)
    # return dummy_gpt(user, message)
    lm_studio(user, message)
  end

  def self.chat_gpt(user, prompt)
    client = OpenAI::Client.new(
      uri_base: ENV["LLM_API_URI_BASE"],
      access_token: ENV["CHAT_GPT_API_KEY"],
    )
    # https://platform.openai.com/docs/models/overview
    # Rails.logger.info(client.models.list.map(&:id))
    client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        stream: proc do |chunk, _bytesize|
          ChatChannel.broadcast_to(user, chunk.dig("choices", 0, "delta", "content"))
        end,
      },
    )
  end

  # @deprecated
  def self.dummy_gpt(user)
    Rails.logger.info("start send message to #{user.email}")
    100.times do
      "Kaigi on Rails!".chars.each do |chunk|
        ChatChannel.broadcast_to(user, chunk)
      end
    end
  end
end
