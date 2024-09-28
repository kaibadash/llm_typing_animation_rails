# frozen_string_literal: true

require "openai"

class ChatGpt
  def self.chat(user_id, message)
    user = User.find(user_id)
    # return dummy_gpt(user, message)
    chat_gpt(user, message)
  end

  def self.chat_gpt(user, prompt)
    client = OpenAI::Client.new(
      uri_base: ENV["LLM_API_URI_BASE"],
      access_token: ENV["CHAT_GPT_API_KEY"],
    )
    # https://platform.openai.com/docs/models/overview
    # Rails.logger.info(client.models.list.map(&:id))
    index = 0
    client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        stream: proc do |chunk, _bytesize|
          Rails.logger.debug(chunk)
          ChatChannel.broadcast_to(user, {
                                     index:,
                                     status: if chunk.dig("choices", 0,
                                                          "finish_reason").present?
                                               :finished
                                             else
                                               :progress
                                             end,
                                     content: chunk.dig("choices", 0, "delta", "content"),
                                   })
          index += 1
        end,
      },
    )
  end

  # @deprecated
  def self.dummy_gpt(user, message)
    Rails.logger.debug("start send message to #{user.email} #{message}")
    index = 0
    100.times do
      "Kaigi on Rails! ".scan(/.{1,2}/).each do |chunk|
        ChatChannel.broadcast_to(user, { index:, status: :progress, content: chunk })
        index += 1
      end
    end
    ChatChannel.broadcast_to(user, { index:, status: :finished })
  end
end
