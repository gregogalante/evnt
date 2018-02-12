# frozen_string_literal: true

require 'rails/generators/base'

module Evnt

  # HandlerGenerator.
  class HandlerGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    argument :informations, type: :array, optional: false

    def create_handler
      path = informations.first.split('::')
      @handler_class = path.last.camelize
      @handler_modules = path - [path.last]
      @handler_events = (informations - [informations.first])

      template(
        './handler/handler.rb.erb',
        handler_path
      )
    end

    def handler_path
      path = './app/handlers'
      @handler_modules.map { |m| path = "#{path}/#{m.underscore}" }
      path = "#{path}/#{@handler_class.underscore}.rb"
      path
    end

  end

end
