# frozen_string_literal: true

require 'rails/generators/base'

module Evnt
  # CrudGenerator.
  class CrudGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc 'This function initialize your Rails project to support a crud.'
    def create_crud_file
      # copy actions
      directory(
        'actions/crud',
        'app/actions/crud'
      )
      # copy events
      directory(
        'events/crud',
        'app/events/crud'
      )
      # copy handlers
      directory(
        'handlers/crud',
        'app/handlers/crud'
      )
    end

  end
end
