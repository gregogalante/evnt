# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Crud
  # Signup event.
  class DestroyEvent < ApplicationEvent

    name_is :cruds_destroy

    attributes_are :uuid, :user_uuid

    handlers_are [
      Crud::DestroyHandler.new
    ]

    to_write_event do
      # save event on model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
