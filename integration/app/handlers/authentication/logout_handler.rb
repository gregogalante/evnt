# frozen_string_literal: true

# Dependencies:
#

module Authentication
  # Handler to manage the logout event.
  class LogoutHandler < Evnt::Handler

    to_manage_event do
      # remove the login from session cache
      sessions_cache = Rails.cache.read(:sessions)
      sessions_cache.delete(event_payload[:uuid])
      Rails.cache.write(:sessions, sessions_cache)
    end

  end
end
