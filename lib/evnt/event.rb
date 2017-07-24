# frozen_string_literal: true

require 'time'

module Evnt
  # Event.
  class Event

    # Constructor.
    def initialize(params, event_reloaded: false)
      # initialize state
      @_state = {
        reloaded: event_reloaded
      }
      # intiialize payload
      if @_state[:reloaded]
        @_payload = params.freeze
      else
        validate_params(params)
        @_payload = get_payload(params).freeze
        _write_event if defined?(_write_event)
      end
      # notify handlers
      notify_handlers
    end

    # This function returns the name of the event.
    def name
      self.class._name
    end

    # This function returns the payload of the event.
    def payload
      @_payload
    end

    # This function tells if the event is reloaded or not.
    def reloaded?
      @_state[:reloaded]
    end

    private

    # This function validates all params and check they are completed.
    def validate_params(params) # TODO: Raise a better error and check it works
      return unless self.class._attributes
      # check all attributes are present
      check_attributes = params.keys == self.class._attributes
      raise 'Event parameters are not correct' unless check_attributes
    end

    # This function return the complete event payload.
    def get_payload(params)
      payload = params
      payload[:_timestamp] = Time.now.to_i
      payload[:_name] = self.class._name
      payload
    end

    # This function notify all handlers for the event.
    def notify_handlers
      return unless self.class._handlers
      # notify every handler
      self.class._handlers.each do |handler|
        handler.notify(self)
      end
    end

    # This class contain the list of settings for the event.
    class << self

      attr_accessor :_name, :_attributes, :_handlers

      # This function sets the name for the event.
      def name_is(event_name)
        instance_variable_set(:@_name, event_name)
      end

      # This function sets the list of attributes for the event.
      def attributes_are(*attributes)
        instance_variable_set(:@_attributes, attributes)
      end

      # This function sets the list of handlers for the event.
      def handlers_are(handlers)
        instance_variable_set(:@_handlers, handlers)
      end

      # This function sets the write event function for the event.
      def to_write_event(&block)
        define_method('_write_event', &block)
      end

    end

  end
end
