# frozen_string_literal: true

# Dependencies:
# - Event model to save event.

module Crud
  # Update event.
  class UpdateEvent < ApplicationEvent

    name_is :cruds_update

    attributes_are :uuid, :title

    handlers_are [
      Crud::UpdateHandler.new
    ]

    to_write_event do
      # save event on model
      raise 'Error on event save' unless Event.create(payload: payload)
    end

  end
end
