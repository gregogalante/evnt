# frozen_string_literal: true

require 'rails/generators/base'

module Evnt
  # InitializerGenerator.
  class InitializerGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc 'This function initialize your Rails project to support Evnt.'
    def create_initializer_file
      # copy initializer
      copy_file('initializer.rb', 'config/initializers/evnt.rb')
      # copy actions
      copy_file(
        'actions/application_action.rb',
        'app/actions/application_action.rb'
      )
      # copy events
      copy_file(
        'events/application_event.rb',
        'app/events/application_event.rb'
      )
      # copy handlers
      copy_file(
        'handlers/application_handler.rb',
        'app/handlers/application_handler.rb'
      )
    end

  end
end
