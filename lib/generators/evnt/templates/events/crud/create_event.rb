# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Crud
  # Create event.
  class CreateEvent < ApplicationEvent

    name_is :cruds_create

    attributes_are :uuid, :title

    handlers_are [
      Crud::CreateHandler.new
    ]

    to_write_event do
      # save event on model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
