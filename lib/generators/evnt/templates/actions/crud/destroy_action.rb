# frozen_string_literal: true

# Dependencies:
# - Queries::Crud model to get the list of saved cruds.

module Crud
  # Action to manage the crud destroy.
  class DestroyAction < ApplicationAction

    to_validate_params do
      # check params presence
      throw 'Uuid should be present' if params[:uuid].blank?
    end

    to_validate_logic do
      # find crud object and check it exists
      crud = Queries::Crud.find_by(uuid: params[:uuid])
      throw 'Crud not found' unless crud
    end

    to_initialize_events do
      # initialize event
      Crud::DestroyEvent.new(uuid: params[:uuid])
    end

  end
end
