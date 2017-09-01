# frozen_string_literal: true

module Evnt

  # Handler.
  class Handler

    attr_reader :event

    # This function is called when an event notify the handler
    def notify(event)
      init_handler_data(event)
      init_handler_steps(event)
      run_handler_steps
    end

    private

    # This function initializes the handler required data.
    def init_handler_data(event)
      @event = event
    end

    # This function init the handler steps.
    def init_handler_steps(event)
      self.class._events[event.name].call
    end

    # This function calls requested steps for the handler.
    def run_handler_steps
      _update_queries if defined?(_update_queries)

      # manage event reloaded
      if event.reloaded?
        _manage_reloaded_event if defined?(_manage_reloaded_event)
        return
      end

      # manage normal event
      _manage_event if defined?(_manage_event)
    end

    # This class contain the list of settings for the handler.
    class << self

      attr_accessor :_events

      # This function sets the blocks executed for a specific event.
      def on(event_name, &block)
        instance_variable_set(:@_events, {}) unless @_events
        @_events[event_name] = block
      end

      # This function sets the update queries function for the event.
      def to_update_queries(&block)
        define_method('_update_queries', &block)
      end

      # This function sets the manage event function for the event.
      def to_manage_event(&block)
        define_method('_manage_event', &block)
      end

      # This function sets the manage reloaded event function for the event.
      def to_manage_reloaded_event(&block)
        define_method('_manage_reloaded_event', &block)
      end

    end

  end

end
