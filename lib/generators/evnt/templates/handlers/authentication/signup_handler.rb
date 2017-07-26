# frozen_string_literal: true

# Dependencies:
# - Queries::User model to save the new user on the read table.

module Authentication
  # Handler to manage the signup event.
  class SignupHandler < ApplicationHandler

    to_update_queries do
      # update query user to save new user
      saved = Queries::User.create(
        uuid: event_payload[:uuid],
        name: event_payload[:name],
        surname: event_payload[:surname],
        email: event_payload[:email],
        password_digest: event_payload[:password_digest]
      )
      raise 'Update queries error' unless saved
    end

  end
end
