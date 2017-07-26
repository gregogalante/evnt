# frozen_string_literal: true

# Dependencies:
# - Queries::Crud model to save the new user on the read table.

module Crud
  # Handler to manage the signup event.
  class DestroyHandler < ApplicationHandler

    to_update_queries do
      # update query crud to remove crud
      crud = Queries::Crud.find_by(uuid: event_payload[:uuid])
      deleted = crud.destroy
      raise 'Update queries error' unless deleted
    end

  end
end
