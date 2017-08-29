# frozen_string_literal: true

require 'rails/generators/base'

module Evnt
  # InitializerGenerator.
  class InitializerGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc 'This function initialize your Rails project to support Evnt.'
    def create_initializer
      manage_actions
      manage_events
      manage_handlers
      manage_application_updates
    end

    private

    def manage_actions
      # copy actions
      copy_file('actions/application_action.rb',
                'app/actions/application_action.rb')
    end

    def manage_events
      # copy events
      copy_file('events/application_event.rb',
                'app/events/application_event.rb')
    end

    def manage_handlers
      # copy handlers
      copy_file('handlers/application_handler.rb',
                'app/handlers/application_handler.rb')
    end

    def manage_application_updates
      # autoload actions directory
      application "config.autoload_paths += %W[\#{Rails.root}/app/actions]"
      # autoload events directory
      application "config.autoload_paths += %W[\#{Rails.root}/app/events]"
      # autoload handlers directory
      application "config.autoload_paths += %W[\#{Rails.root}/app/handlers]"
    end

  end
end
