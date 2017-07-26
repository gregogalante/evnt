# frozen_string_literal: true

# Dependencies:
# - Queries::Crud model to get the list of saved cruds.

module Crud
  # Action to manage users login.
  class CreateAction < ApplicationAction

    to_validate_params do
      # check params presence
      throw 'Title should be present' if params[:title].blank?
    end

    to_validate_logic do
      # check no others crud exists with same title
      same_cruds = Queries::Crud.where(title: params[:title])
      throw 'Crud already exists' unless same_cruds.empty?
    end

    to_initialize_events do
      # generate uuid
      uuid = SecureRandom.uuid
      # initialize event
      Crud::CreateEvent.new(
        uuid: uuid,
        title: params[:title]
      )
    end

  end
end
