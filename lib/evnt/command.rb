# frozen_string_literal: true

module Evnt

  # Command.
  class Command

    attr_reader :params

    def initialize(params, options: {})
      init_command_data(params, options)
      run_command_steps
    end

    # This function returns the list of errors of the command.
    def errors
      @state[:errors]
    end

    # This function returns the list of error messages of the command.
    def error_messages
      @state[:errors].select { |e| e[:message] }
    end

    # This function returns the list of error codes of the command.
    def error_codes
      @state[:errors].select { |e| e[:code] }
    end

    # This function tells if the command is completed or not.
    def completed?
      @state[:result]
    end

    protected

    # This function can be used to stop the command execution and
    # add a new error.
    def throw(message, code: nil)
      @state[:result] = false
      @state[:errors].push(
        message: message,
        code: code
      )

      # raise error if command needs exceptions
      raise error if @options[:exceptions]
    end

    private

    # This function initializes the command required data.
    def init_command_data(params, options)
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

    # This function calls requested steps for the command.
    def run_command_steps
      validate_params if @state[:result] && defined?(validate_params)
      validate_logic if @state[:result] && defined?(validate_logic)
      initialize_events if @state[:result] && defined?(initialize_events)
    end

    # This class contain the list of settings for the command.
    class << self

      # This function sets the validate params function for the command.
      def to_validate_params(&block)
        define_method('validate_params', &block)
      end

      # This function sets the validate logic function for the command.
      def to_validate_logic(&block)
        define_method('validate_logic', &block)
      end

      # This function sets the intitialize events function for the command.
      def to_initialize_events(&block)
        define_method('initialize_events', &block)
      end

    end

  end

end
