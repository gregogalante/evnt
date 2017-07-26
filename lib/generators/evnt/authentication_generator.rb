# frozen_string_literal: true

require 'rails/generators/base'

module Evnt
  # AuthenticationGenerator.
  class AuthenticationGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc 'This function initialize your Rails project to support user authentication.'
    def create_authentication_file
      # copy actions
      directory(
        'actions/authentication',
        'app/actions/authentication'
      )
      # copy events
      directory(
        'events/authentication',
        'app/events/authentication'
      )
      # copy handlers
      directory(
        'handlers/authentication',
        'app/handlers/authentication'
      )
    end

  end
end
