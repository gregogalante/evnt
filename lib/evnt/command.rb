# frozen_string_literal: true

module Evnt

  ##
  # Commands are used to run single tasks on the system.
  # It's like a controller on an MVC architecture without the
  # communication with the client.
  ##
  class Command

    ##
    # Attribute containings the list of command parameters.
    ##
    attr_reader :params

    ##
    # The constructor is used to run a new command.
    #
    # ==== Attributes
    #
    # * +params+ - The list of parameters for the command.
    # * +_options+ - The list of options for the command.
    #
    # ==== Options
    #
    # * +exceptions+ - Boolean value used to activate the throw of excetions.
    # * +nullify_empty_params+ - Transform empty params to nil values so the validator
    # should consider them as nil values.
    ##
    def initialize(params = {})
      _init_command_data(params)
      _run_command_steps
    end

    # Public functions:
    ############################################################################

    ##
    # This function returns the list of errors of the command.
    # The returned object should be an array of hashes with a message and
    # a code value.
    # The code value of hashes should be nil if code is not defined using
    # the stop() function.
    ##
    def errors
      @state[:errors]
    end

    ##
    # This function returns the list of error messages of the command.
    # The returned object should be an array of strings.
    ##
    def error_messages
      @state[:errors].map { |e| e[:message] }
    end

    ##
    # This function returns the list of error codes of the command.
    # The returned object should be an array of integers.
    ##
    def error_codes
      @state[:errors].map { |e| e[:code] }
    end

    ##
    # This function tells if the command is completed or not.
    # The returned object should be a boolean value.
    ##
    def completed?
      @state[:result]
    end

    # Protected functions:
    ############################################################################

    protected

    ##
    # This function can be used to stop the command execution and
    # add a new error.
    # Using err inside a callback should not stop the execution but
    # should avoid the call of the next callback.
    # Every time you call this function, a new error should be added
    # to the errors list.
    # If the exceptions option is active, it should raise a new error.
    #
    # ==== Attributes
    #
    # * +message+ - The message string of the error.
    # * +code+ - The error code.
    ##
    def err(message, code: nil)
      @state[:result] = false
      @state[:errors].push(
        message: message,
        code: code
      )

      # raise error if command needs exceptions
      raise message if @options[:exceptions]
    end

    # Private functions:
    ############################################################################

    private

    # This function initializes the command required data.
    def _init_command_data(params)
      # set state
      @state = {
        result: true,
        errors: []
      }

      # set options
      initial_options = {
        exceptions: false,
        nullify_empty_params: false
      }
      default_options = _safe_default_options || {}
      params_options = params[:_options] || {}
      @options = initial_options.merge(default_options)
                                .merge(params_options)

      # set other data
      @params = params
    end

    # This function calls requested steps (callback) for the command.
    def _run_command_steps
      _validate_single_params
      _safe_normalize_params if @state[:result]
      _safe_validate_params if @state[:result]
      _safe_validate_logic if @state[:result]
      _safe_initialize_events if @state[:result]
    end

    # This function validates the single parameters sets with the "validates" method.
    def _validate_single_params
      validations = _safe_validations
      validations.each do |val|
        value_to_validate = _value_to_validate(val)
        validator = Evnt::Validator.new(value_to_validate, val[:options])

        if validator.passed?
          @params[val[:param]] = validator.value
        else
          err val[:options][:err] || "#{val[:param].capitalize} value not accepted"
          break
        end
      end

      @params
    end

    def _value_to_validate(val)
      return nil if @options[:nullify_empty_params] && params[val[:param]].empty?
      params[val[:param]]
    rescue StandardError
      params[val[:param]]
    end

    # Safe defined functions:

    def _safe_default_options
      return _default_options if defined?(_default_options)
      {}
    end

    def _safe_validations
      return _validations if defined?(_validations)
      []
    end

    def _safe_normalize_params
      return _normalize_params if defined?(_normalize_params)
      nil
    end

    def _safe_validate_params
      return _validate_params if defined?(_validate_params)
      nil
    end

    def _safe_validate_logic
      return _validate_logic if defined?(_validate_logic)
      nil
    end

    def _safe_initialize_events
      return _initialize_events if defined?(_initialize_events)
      nil
    end

    # Class functions:
    ############################################################################

    # This class contain the list of settings for the command.
    class << self

      # This function sets the default options that should be used by the command.
      def default_options(*options)
        @@options ||= {}
        @@options.merge!(options)

        define_method('_default_options', -> { return @@options })
      end

      # This function sets the single validation request for a command parameter.
      def validates(param, options)
        @@validations ||= []
        @@validations.push(param: param, options: options)

        define_method('_validations', -> { return @@validations })
      end

      # This function sets the normalize params function for the command.
      def to_normalize_params(&block)
        define_method('_normalize_params', &block)
      end

      # This function sets the validate params function for the command.
      def to_validate_params(&block)
        define_method('_validate_params', &block)
      end

      # This function sets the validate logic function for the command.
      def to_validate_logic(&block)
        define_method('_validate_logic', &block)
      end

      # This function sets the intitialize events function for the command.
      def to_initialize_events(&block)
        define_method('_initialize_events', &block)
      end

    end

  end

end
