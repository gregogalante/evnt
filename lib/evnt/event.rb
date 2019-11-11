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
    # Attribute containings the list of payload attributes of the event.
    ##
    attr_reader :payload_attributes

    ##
    # Attribute containings the list of extras attributes of the event.
    ##
    attr_reader :extras_attributes

    ##
    # DEPRECATED: Attribute containings the list of attributes of the event.
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
      _validate_extras
      _run_event_steps
      _notify_handlers if @state[:saved]
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

    ##
    # This function tells if the event is saved or not.
    # As default an event is considered saved. It should be updated to
    # not saved when the to_write_event has some problems.
    ##
    def saved?
      @state[:saved]
    end

    ##
    # This function can be used to set the event as not saved.
    # A not saved event should not notify handlers.
    # If the exceptions option is active, it should raise a new error.
    ##
    def set_not_saved
      @state[:saved] = false

      # raise error if event needs exceptions
      raise 'Event can not be saved' if @options[:exceptions]
    end

    # Private functions:
    ############################################################################

    private

    # This function initializes the event required data.
    def _init_event_data(params)
      # set state
      @state = {
        reloaded: !params[:evnt].nil?,
        saved: true
      }

      # set options
      initial_options = {
        exceptions: false,
        silent: false
      }
      default_options = _safe_default_options || {}
      params_options = params[:_options] || {}
      @options = initial_options.merge(default_options)
                                .merge(params_options)

      # set name and attributes
      @name = _safe_name
      @payload_attributes = _safe_payload_attributes
      @extras_attributes = _safe_extras_attributes
      @attributes = _safe_payload_attributes # DEPRECATED

      # set payload
      payload = params.reject { |k, _v| k[0] == '_' }
      @payload = @state[:reloaded] ? payload : _generate_payload(payload)

      # set extras
      @extras = {}
      extras = params.select { |k, _v| k[0] == '_' }
      extras.each { |k, v| @extras[k[1..-1].to_sym] = v }
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
      check_attr = (@payload.keys - [:evnt]).sort == @payload_attributes.sort
      raise 'Event parameters are not correct' unless check_attr
    end

    # This function validates all extras and check they are completed.
    def _validate_extras
      # check all attributes are present
      check_attr = @extras.keys.sort == @extras_attributes.sort
      puts 'Event extras are not correct; in future releases they will be required' unless check_attr
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

    def _safe_payload_attributes
      return _payload_attributes if defined?(_payload_attributes)
      []
    end

    def _safe_extras_attributes
      return _extras_attributes if defined?(_extras_attributes)
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
        @@options ||= {}
        @@options.merge!(options)

        define_method('_default_options', -> { @@options })
      end

      # This function sets the name for the event.
      def name_is(name)
        define_method('_name', -> { return name })
      end

      # This function sets the list of payload attributes for the event.
      def payload_attributes_are(*attributes)
        @@payload_attributes ||= []
        @@payload_attributes.concat(attributes).uniq!

        define_method('_payload_attributes', -> { @@payload_attributes })
      end

      # This function sets the list of extras attributes for the event.
      def extras_attributes_are(*attributes)
        @@extras_attributes ||= []
        @@extras_attributes.concat(attributes).uniq!

        define_method('_extras_attributes', -> { @@extras_attributes })
      end

      # DEPRECATED: This function sets the list of attributes for the event.
      def attributes_are(*attributes)
        @@payload_attributes ||= []
        @@payload_attributes.concat(attributes).uniq!

        define_method('_payload_attributes', -> { @@payload_attributes })
      end

      # This function sets the list of handlers for the event.
      def handlers_are(handlers)
        @@handlers ||= []
        @@handlers.concat(handlers)

        define_method('_handlers', -> { @@handlers })
      end

      # This function sets the write event function for the event.
      def to_write_event(&block)
        define_method('_write_event', &block)
      end

      # This function is used to add a new handler to the event from the external.
      def add_handler(handler)
        @@handlers ||= []
        @@handlers.push(handler)

        define_method('_handlers', -> { @@handlers })
      end

    end

  end

end
