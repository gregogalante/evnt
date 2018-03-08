# frozen_string_literal: true

require 'rails/generators/base'

module Evnt

  # InitializerGenerator.
  class InitializerGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    class_option :migrated, type: :boolean, default: false,
                            desription: 'Include migration for a model used to save events.'

    def create_initializer
      directory './initializer', './'
      update_config_application

      manage_migrated_option
    end

    def update_config_application
      application "config.autoload_paths += %W[\#{Rails.root}/app/commands]"
      application "config.autoload_paths += %W[\#{Rails.root}/app/events]"
      application "config.autoload_paths += %W[\#{Rails.root}/app/handlers]"
    end

    def manage_migrated_option
      return unless options[:migrated]

      invoke 'model', ['EvntEvent', 'name:string', 'payload:text']
    end

  end

end
