# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { "test#{rand(100_000)}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
