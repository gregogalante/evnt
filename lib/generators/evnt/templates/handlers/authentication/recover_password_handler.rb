# frozen_string_literal: true

# Dependencies:
# - Queries::User model to save the new user on the read table.

module Authentication
  # Handler to manage the request recover password event.
  class RecoverPasswordHandler < ApplicationHandler

    to_update_queries do
      user = Queries::User.find_by(uuid: event_payload[:uuid])
      saved = user.update(password_digest: event_payload[:password_digest])
      raise 'Update queries error' unless saved
    end

  end
end
