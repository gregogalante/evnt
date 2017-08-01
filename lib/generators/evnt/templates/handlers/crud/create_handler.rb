# frozen_string_literal: true

# Dependencies:
# - Queries::Crud model to save the new user on the read table.

module Crud
  # Handler to manage the create event.
  class CreateHandler < ApplicationHandler

    to_update_queries do
      # update query crud to save new crud
      saved = Queries::Crud.create(
        uuid: event_payload[:uuid],
        title: event_payload[:title]
      )
      raise 'Update queries error' unless saved
    end

  end
end
