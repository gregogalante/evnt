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
    ##
    def initialize(params, _options: {})
      _init_command_data(params, _options)
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
    # Using stop inside a callback should not stop the execution but
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
    def stop(message, code: nil)
      @state[:result] = false
      @state[:errors].push(
        message: message,
        code: code
      )

      # raise error if command needs exceptions
      raise error if @options[:exceptions]
    end

    ##
    # This function validates the presence of a list of parameters.
    # The presence validation should check that every parameter exist
    # and is not nil.
    # The returned object should be a boolean value.
    #
    # ==== Attributes
    # * +attributes+ - The array of attributes keys that should be validated.
    ##
    def params_presence?(attributes)
      attributes.each do |attribute|
        return false if @params[attribute].nil?
      end

      true
    end

    # Private functions:
    ############################################################################

    private

    # This function initializes the command required data.
    def _init_command_data(params, options)
      # set state
      @state = {
        result: true,
        errors: []
      }

      # set options
      @options = {
        exceptions: options[:exceptions] || false
      }

      # set other data
      @params = params.freeze
    end

    # This function calls requested steps (callback) for the command.
    def _run_command_steps
      _validate_params if @state[:result] && defined?(_validate_params)
      _validate_logic if @state[:result] && defined?(_validate_logic)
      _initialize_events if @state[:result] && defined?(_initialize_events)
    end

    # Class functions:
    ############################################################################

    # This class contain the list of settings for the command.
    class << self

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
