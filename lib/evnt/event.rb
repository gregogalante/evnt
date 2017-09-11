# frozen_string_literal: true

require 'time'

module Evnt

  # Event.
  class Event

    attr_reader :name, :attributes, :payload, :extras

    # Constructor.
    def initialize(params)
      _init_event_data(params)
      _validate_payload
      _run_event_steps
      _notify_handlers
    end

    # Public functions:
    ############################################################################

    # This function tells if the event is reloaded or not.
    def reloaded?
      @state[:reloaded]
    end

    # Private functions:
    ############################################################################

    private

    # This function validates all payload and check they are completed.
    def _validate_payload
      return unless self.class._attributes

      # check all attributes are present
      check_attr = @payload.keys == (self.class._attributes - :evnt)
      raise 'Event parameters are not correct' unless check_attr
    end

    # This function initializes the event required data.
    def _init_event_data(params)
      # set state
      @state = {
        reloaded: !params[:evnt].nil?
      }

      # set payload
      payload = params.reject { |k, _v| k[0] == '_' }
      @payload = @state[:reloaded] ? payload : _generate_payload(payload)
      @payload.freeze

      # set other datas
      @name = self.class._name
      @attributes = self.class._attributes
      @extras = params.select { |k, _v| k[0] == '_' }
    end

    # This function calls requested steps for the event.
    def _run_event_steps
      _write_event if defined?(_write_event)
    end

    # This function generates the complete event payload.
    def _generate_payload(params)
      # add evnt informations
      params[:evnt] = {
        timestamp: Time.now.to_i,
        name: self.class._name
      }
      # return payload
      params
    end

    # This function notify all handlers for the event.
    def _notify_handlers
      return unless self.class._handlers

      # notify every handler
      self.class._handlers.each do |handler|
        handler.notify(self)
      end
    end

    # Class functions:
    ############################################################################

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
