# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Authentication
  # RecoverPassword event.
  class RecoverPasswordEvent < ApplicationEvent

    name_is :authentication_recover_password

    attributes_are :uuid, :password_digest

    handlers_are [
      Authentication::RecoverPasswordHandler.new
    ]

    to_write_event do
      # save event on model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
