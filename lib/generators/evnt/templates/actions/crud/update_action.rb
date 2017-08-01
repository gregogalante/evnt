# frozen_string_literal: true

# Dependencies:
# - Queries::Crud model to get the list of saved cruds.

module Crud
  # Action to manage the crud update.
  class UpdateAction < ApplicationAction

    to_validate_params do
      # check params presence
      throw 'Uuid should be present' if params[:uuid].blank?
      throw 'Title should be present' if params[:title].blank?
    end

    to_validate_logic do
      # find crud object and check it exists
      crud = Queries::Crud.find_by(uuid: params[:uuid])
      throw 'Crud not found' unless crud
      # check user can delete crud object
      throw 'You do not have permission to run this action' unless crud.user_uuid == params[:user_uuid]
    end

    to_initialize_events do
      # initialize event
      Crud::UpdateEvent.new(
        uuid: params[:uuid],
        title: params[:title]
      )
    end

  end
end
