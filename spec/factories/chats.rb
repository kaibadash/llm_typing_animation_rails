# frozen_string_literal: true

FactoryBot.define do
  factory :chat do
    message { "いちご#{rand(101)}%" }
  end
end
