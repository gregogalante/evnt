# frozen_string_literal: true

# Dependencies:
# - Queries::Crud model to save the new user on the read table.

module Crud
  # Handler to manage the update event.
  class UpdateHandler < ApplicationHandler

    to_update_queries do
      # update query crud to update crud object
      crud = Queries::Crud.find_by(uuid: event_payload[:uuid])
      saved = crud.update(title: event_payload[:title])
      raise 'Update queries error' unless saved
    end

  end
end
