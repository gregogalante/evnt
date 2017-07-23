# frozen_string_literal: true

module Evnt
  # Action.
  class Action

    def initialize(params, action_exceptions: false)
      # initialize action
      @_params = params.freeze
      @_state = {
        exceptions: action_exceptions,
        result: true,
        errors: []
      }
      # call functions
      _validate_params if @_state[:result] && defined?(_validate_params)
      _validate_logic if @_state[:result] && defined?(_validate_logic)
      _initialize_events if @_state[:result] && defined?(_initialize_events)
    end

    # This function returns the list of paramteters of the action.
    def params
      @_params
    end

    # This function returns the list of errors of the action.
    def errors
      @_state[:errors]
    end

    # This function tells if the action is completed or not.
    def completed?
      @_state[:result]
    end

    protected

    # This function can be used to stop the action execution and
    # add a new error.
    def throw(error)
      @_state[:result] = false
      @_state[:errors].push(error)
      # raise error if action needs exceptions
      raise error if @_state[:exceptions]
    end

    # This class contain the list of settings for the action.
    class << self

      # This function sets the validate params function for the action.
      def to_validate_params(&block)
        define_method('_validate_params', &block)
      end

      # This function sets the validate logic function for the action.
      def to_validate_logic(&block)
        define_method('_validate_logic', &block)
      end

      # This function sets the intitialize events function for the action.
      def to_initialize_events(&block)
        define_method('_initialize_events', &block)
      end

    end

  end
end
