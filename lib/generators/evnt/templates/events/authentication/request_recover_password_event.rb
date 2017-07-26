# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Authentication
  # RequestRecoverPassword event.
  class RequestRecoverPasswordEvent < Evnt::Event

    name_is :authentication_request_recover_password

    attributes_are :email, :security_token

    handlers_are [
      Authentication::RequestRecoverPasswordHandler.new
    ]

    to_write_event do
      # save event on model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
