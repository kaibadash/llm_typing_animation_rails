# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChatGpt, type: :model do
  before do
    allow(ChatChannel).to receive(:broadcast_to)
  end

  describe ".chat" do
    let!(:user) { create(:user) }
    let!(:message) { "二千二十四は数字でいうと? 数字のみ出力してください。" }
    let!(:chat) { create(:chat) }

    it "got LLM response", :vcr do
      expect(chat.id).to eq(1)
    end
  end
end
