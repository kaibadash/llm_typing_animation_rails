# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :unique_identifier

    def connect
      self.unique_identifier = SecureRandom.uuid
      # ここでユーザーを一意に識別するための任意の方法を設定します。
      # 例えば、セッションIDやクッキーからユーザーIDを取得するなど。
      # 認証が不要な場合は、上記のようにランダムなUUIDを使用しても構いません。
    end
  end
end
