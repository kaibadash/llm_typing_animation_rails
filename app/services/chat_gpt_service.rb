require 'openai'

class ChatGptService
  def self.chat(message)
    client = OpenAI::Client.new(access_token: ENV['CHAT_GPT_API_KEY'])
    # https://platform.openai.com/docs/models/overview
    # Rails.logger.info(client.models.list.map(&:id))
    client.chat(
        parameters: {
            model: "gpt-4",
            messages: [{ role: "user", content: message}],
            stream: proc do |chunk, _bytesize|
                print chunk.dig("choices", 0, "delta", "content")
            end
        }
    )
  end
end
