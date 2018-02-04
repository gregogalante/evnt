# frozen_string_literal: true

require 'rails/generators/base'

module Evnt

  # InitializerGenerator.
  class InitializerGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    def create_initializer
      directory './initializer', './'
      update_config_application
    end

    def update_config_application
      application "config.autoload_paths += %W[\#{Rails.root}/app/commands]"
      application "config.autoload_paths += %W[\#{Rails.root}/app/events]"
      application "config.autoload_paths += %W[\#{Rails.root}/app/handlers]"
    end

  end

end
