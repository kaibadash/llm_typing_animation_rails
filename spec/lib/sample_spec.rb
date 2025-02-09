# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChatGpt, type: :model do
  before do
    allow(ChatChannel).to receive(:broadcast_to)
  end

  describe ".chat" do
    let!(:user) { create(:user) }
    let!(:message) { "sample" }
    let!(:chat) { create(:chat) }

    it "got LLM response", :vcr do
      expect(chat.id).to eq(1)
    end
  end
end
