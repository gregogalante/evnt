# frozen_string_literal: true

require 'time'

module Evnt

  # Event.
  class Event

    attr_reader :name, :attributes, :payload, :extras

    # Constructor.
    def initialize(params)
      init_event_data(params)
      run_event_steps
      notify_handlers
    end

    # This function tells if the event is reloaded or not.
    def reloaded?
      @state[:reloaded]
    end

    private

    # This function validates all params and check they are completed.
    def validate_params(params)
      return unless self.class.attributes

      # check all attributes are present
      check_attr = params.keys == (self.class.attributes - :evnt)
      raise 'Event parameters are not correct' unless check_attr
    end

    # This function initializes the event required data.
    def init_event_data(params)
      # set state
      @state = {
        reloaded: !params[:evnt].nil?
      }

      # set payload
      payload = params.reject { |k, _v| k[0] == '_' }
      @payload = @state[:reloaded] ? payload : generate_payload(payload)
      @payload.freeze

      # set other datas
      @name = self.class.name
      @attributes = self.class.attributes
      @extras = params.select { |k, _v| k[0] == '_' }
    end

    # This function calls requested steps for the event.
    def run_event_steps
      write_event if defined?(write_event)
    end

    # This function generates the complete event payload.
    def generate_payload(params)
      # add evnt informations
      params[:evnt] = {
        timestamp: Time.now.to_i,
        name: self.class.name
      }
      # return payload
      params
    end

    # This function notify all handlers for the event.
    def notify_handlers
      return unless self.class.handlers

      # notify every handler
      self.class.handlers.each do |handler|
        handler.notify(self)
      end
    end

    # This class contain the list of settings for the event.
    class << self

      attr_accessor :name, :attributes, :handlers

      # This function sets the name for the event.
      def name_is(event_name)
        instance_variable_set(:@name, event_name)
      end

      # This function sets the list of attributes for the event.
      def attributes_are(*attributes)
        instance_variable_set(:@attributes, attributes)
      end

      # This function sets the list of handlers for the event.
      def handlers_are(handlers)
        instance_variable_set(:@handlers, handlers)
      end

      # This function sets the write event function for the event.
      def to_write_event(&block)
        define_method('write_event', &block)
      end

    end

  end

end
