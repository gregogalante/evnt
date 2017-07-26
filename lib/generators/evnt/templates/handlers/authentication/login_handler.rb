# frozen_string_literal: true

# Dependencies:
# - SessionsCache class used to write and read memory cache datas.

module Authentication
  # Hander to manage the login event.
  class LoginHandler < Evnt::Handler

    to_manage_event do
      # write the login on sessions cache
      SessionsCache.create_session(event_payload[:uuid])
    end

  end
end
