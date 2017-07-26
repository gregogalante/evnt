# frozen_string_literal: true

# Dependencies:
#

module Authentication
  # Hander to manage the login event.
  class LoginHandler < Evnt::Handler

    to_manage_event do
      # write the login on sessions cache
      sessions_cache = Rails.cache.read(:sessions)
      sessions_cache[event_payload[:uuid]] = Time.now.to_i
      Rails.cache.write(:sessions, sessions_cache)
    end

  end
end
