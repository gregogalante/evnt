# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Authentication
  # Signup event.
  class SignupEvent < ApplicationEvent

    name_is :authentication_signup

    attributes_are :uuid, :name, :surname, :email, :password_digest

    handlers_are [
      Authentication::SignupHandler.new
    ]

    to_write_event do
      # save event on model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
