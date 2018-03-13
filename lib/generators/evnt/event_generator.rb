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
      @event_name = event_name_clean(path.map(&:underscore).join('_'))
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

    def event_name_clean(event_name)
      return event_name unless event_name.end_with?('_event')

      event_name.gsub('_event', '')
    end

  end

end
