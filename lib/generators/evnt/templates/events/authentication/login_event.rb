# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Authentication
  # Login event.
  class LoginEvent < ApplicationEvent

    name_is :authentication_login

    attributes_are :uuid

    handlers_are [
      Authentication::LoginHandler.new
    ]

    to_write_event do
      # save event on event model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
