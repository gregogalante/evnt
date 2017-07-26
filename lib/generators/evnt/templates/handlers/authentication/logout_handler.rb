# frozen_string_literal: true

# Dependencies:
# - SessionsCache class used to write and read memory cache datas.

module Authentication
  # Handler to manage the logout event.
  class LogoutHandler < Evnt::Handler

    to_manage_event do
      # remove the login from session cache
      SessionsCache.destroy_session(event_payload[:uuid])
    end

  end
end
