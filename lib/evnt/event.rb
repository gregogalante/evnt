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
      default_options = _safe_default_options || {}
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
      @name = _safe_name
      @attributes = _safe_attributes
    end

    # This function generates the complete event payload.
    def _generate_payload(params)
      # add evnt informations
      params[:evnt] = {
        timestamp: Time.now.to_i,
        name: @name
      }
      # return payload
      params
    end

    # This function validates all payload and check they are completed.
    def _validate_payload
      # check all attributes are present
      check_attr = (@payload.keys - [:evnt]) == @attributes
      raise 'Event parameters are not correct' unless check_attr
    end

    # This function calls requested steps for the event.
    def _run_event_steps
      _safe_write_event
    end

    # This function notify all handlers for the event.
    def _notify_handlers
      return if @options[:silent]
      handlers = _safe_handlers

      # notify every handler
      handlers.each do |handler|
        handler.notify(self)
      end
    end

    # Safe defined functions:

    def _safe_default_options
      return _default_options if defined?(_default_options)
      {}
    end

    def _safe_name
      return _name if defined?(_name)
      ''
    end

    def _safe_attributes
      return _attributes if defined?(_attributes)
      []
    end

    def _safe_handlers
      return _handlers if defined?(_handlers)
      []
    end

    def _safe_write_event
      return _write_event if defined?(_write_event)
      nil
    end

    # Class functions:
    ############################################################################

    # This class contain the list of settings for the event.
    class << self

      # This function sets the default options that should be used by the event.
      def default_options(options)
        @options ||= {}
        @options.merge!(options)
        event_options = @options

        define_method('_default_options', -> { return event_options })
      end

      # This function sets the name for the event.
      def name_is(name)
        define_method('_name', -> { return name })
      end

      # This function sets the list of attributes for the event.
      def attributes_are(*attributes)
        @attributes ||= []
        @attributes.concat(attributes).uniq!
        event_attributes = @attributes

        define_method('_attributes', -> { return event_attributes })
      end

      # This function sets the list of handlers for the event.
      def handlers_are(handlers)
        @handlers ||= []
        @handlers.concat(handlers)
        event_handlers = @handlers

        define_method('_handlers', -> { return event_handlers })
      end

      # This function sets the write event function for the event.
      def to_write_event(&block)
        define_method('_write_event', &block)
      end

    end

  end

end
