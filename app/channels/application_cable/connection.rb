module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
      reject_unauthorized_connection unless self.current_user
    end

    private

    def find_current_user
      if remember_token.present?
        @current_user ||= user_from_remember_token(remember_token)
      end

      @current_user
    end

    def cookies
      @cookies ||= ActionDispatch::Request.new(@env).cookie_jar
    end

    def remember_token
      cookies[Clearance.configuration.cookie_name]
    end

    def user_from_remember_token(token)
      Clearance.configuration.user_model.find_by(remember_token: token)
    end
  end
end
