# frozen_string_literal: true

require 'time'

module Evnt

  ##
  # Events are used to save on a persistent data structure what
  # happends on the system.
  ##
  class Event

    ##
    # Attribute containings the name of the event.
    ##
    attr_reader :name

    ##
    # Attribute containings the list of attributes of the event.
    ##
    attr_reader :attributes

    ##
    # Attribute containings the payload of the event.
    ##
    attr_reader :payload

    ##
    # Attribute containings the extra parameters of the event.
    ##
    attr_reader :extras

    ##
    # The constructor is used to initialize a new event.
    # The parameters are validated and added to the payload
    # of the event. The parameters with the _ in their name
    # are not saved on the payload.
    #
    # ==== Attributes
    #
    # * +params+ - The list of parameters for the event.
    # * +_options+ - The list of options for the event.
    #
    # ==== Options
    #
    # * +silent+ - Boolean value used to avoid the call of the notify method of
    # handlers.
    ##
    def initialize(params = {})
      _init_event_data(params)
      _validate_payload
      _run_event_steps
      _notify_handlers
    end

    # Public functions:
    ############################################################################

    ##
    # This function tells if the event is reloaded or not.
    # The returned object should be a boolean value corresponding to the
    # presence of evnt value inside the event params.
    ##
    def reloaded?
      @state[:reloaded]
    end

    # Private functions:
    ############################################################################

    private

    # This function initializes the event required data.
    def _init_event_data(params)
      # set state
      @state = {
        reloaded: !params[:evnt].nil?
      }

      # set options
      initial_options = {
        silent: false
      }
      default_options = @_default_options || {}
      params_options = params[:_options] || {}
      @options = initial_options.merge(default_options)
                                .merge(params_options)

      # set payload
      payload = params.reject { |k, _v| k[0] == '_' }
      @payload = @state[:reloaded] ? payload : _generate_payload(payload)

      # set extras
      @extras = {}
      extras = params.select { |k, _v| k[0] == '_' }
      extras.each { |k, v| @extras[k[1..-1].to_sym] = v }

      # set other datas
      @name = self.class._name
      @attributes = self.class._attributes
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

    # This function validates all payload and check they are completed.
    def _validate_payload
      return unless self.class._attributes

      # check all attributes are present
      check_attr = (@payload.keys - [:evnt]) == self.class._attributes
      raise 'Event parameters are not correct' unless check_attr
    end

    # This function calls requested steps for the event.
    def _run_event_steps
      _write_event if defined?(_write_event)
    end

    # This function notify all handlers for the event.
    def _notify_handlers
      return unless self.class._handlers
      return if @options[:silent]

      # notify every handler
      self.class._handlers.each do |handler|
        handler.notify(self)
      end
    end

    # Class functions:
    ############################################################################

    # This class contain the list of settings for the event.
    class << self

      attr_accessor :_default_options, :_name, :_attributes, :_handlers

      # This function sets the default options that should be used by the event.
      def default_options(options)
        instance_variable_set(:@_default_options, options)
      end

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
