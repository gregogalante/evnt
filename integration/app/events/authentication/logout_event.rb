# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Authentication
  # Logout event.
  class LogoutEvent < Evnt::Event

    name_is :authentication_logout

    attributes_are :uuid

    handlers_are [
      Authentication::LogoutHandler.new
    ]

    to_write_event do
      # save event on model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
