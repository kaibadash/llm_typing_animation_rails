module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
    end

    private

      def find_current_user
        current_user = env['warden'].user
        Rails.logger.info("find_current_user: #{current_user&.email}")
        if current_user.blank?
          return reject_unauthorized_connection
        end

        current_user
      end
  end
end
