# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChatGpt, type: :model do
  before do
    allow(ChatChannel).to receive(:broadcast_to)
  end

  describe ".chat" do
    let(:user) { create(:user) }
    let(:message) { "二千二十四は数字でいうと? 数字のみ出力してください。" }

    it "got LLM response", :vcr do
      VCR.use_cassette("chatgpt/succeeded") do
        ChatGpt.chat(user.id, message)
      end
      expect(ChatChannel).to have_received(:broadcast_to).with(
        user, hash_including(content: "202")
      )
      expect(ChatChannel).to have_received(:broadcast_to).with(
        user, hash_including(content: "4")
      )
    end
  end
end
