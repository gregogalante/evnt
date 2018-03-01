# frozen_string_literal: true

module Evnt

  ##
  # Handlers are used to listen one or more events and run tasks after their execution.
  ##
  class Handler

    ##
    # Attribute containings the event that notify the handler.
    ##
    attr_reader :event

    ##
    # This function is called from an event to notify an handler.
    #
    # ==== Attributes
    #
    # * +event+ - The event object that call the function.
    ##
    def notify(event)
      _init_handler_data(event)
      _run_handler_steps
    end

    # Private functions:
    ############################################################################

    private

    # This function initializes the handler required data.
    def _init_handler_data(event)
      @event = event
    end

    # This function calls requested steps for the handler.
    def _run_handler_steps
      _safe_update_queries(@event.name)

      if event.reloaded?
        # manage event reloaded
        _safe_manage_reloaded_event(@event.name)
      else
        # manage normal event
        _safe_manage_event(@event.name)
      end
    end

    # Safe defined functions:

    def _safe_update_queries(event)
      update_queries = "#{event}_update_queries"
      return send(update_queries) if respond_to? update_queries
      nil
    end

    def _safe_manage_reloaded_event(event)
      manage_reloaded_event = "#{event}_manage_reloaded_event"
      return send(manage_reloaded_event) if respond_to? manage_reloaded_event
      nil
    end

    def _safe_manage_event(event)
      manage_event = "#{event}_manage_event"
      return send(manage_event) if respond_to? manage_event
      nil
    end

    # Class functions:
    ############################################################################

    # This class contain the list of settings for the handler.
    class << self

      # This function sets the blocks executed for a specific event.
      def on(event_name, &block)
        @_current_event_name = event_name
        block.yield
      end

      # This function sets the update queries function for the event.
      def to_update_queries(&block)
        define_method("#{@_current_event_name}_update_queries", &block)
      end

      # This function sets the manage event function for the event.
      def to_manage_event(&block)
        define_method("#{@_current_event_name}_manage_event", &block)
      end

      # This function sets the manage reloaded event function for the event.
      def to_manage_reloaded_event(&block)
        define_method("#{@_current_event_name}_manage_reloaded_event", &block)
      end

    end

  end

end
