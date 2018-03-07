# frozen_string_literal: true

require 'rails/generators/base'

module Evnt

  # EventGenerator.
  class EventGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    argument :informations, type: :array, optional: false

    def create_event
      path = informations.first.split('::')
      @event_class = path.last.camelize
      @event_modules = path - [path.last]
      @event_name = path.map(&:underscore).join('_') # TODO: Remove "event" at the end of name if it's present.
      @event_attributes = (informations - [informations.first]).map { |a| ":#{a}" }.join(', ')

      template(
        './event/event.rb.erb',
        event_path
      )
    end

    def event_path
      path = './app/events'
      @event_modules.map { |m| path = "#{path}/#{m.underscore}" }
      path = "#{path}/#{@event_class.underscore}.rb"
      path
    end

  end

end
