# frozen_string_literal: true

module Evnt
  # Handler.
  class Handler

    # This function is called when an event notify the handler
    def notify(event)
      # initialize state
      @_state = {}
      # initialize event
      @_event = event.freeze
      # call functions
      _update_queries if defined?(_update_queries)
      _manage_event if defined?(_manage_event) && !event.reloaded?
    end

    # This function return the event object.
    def event
      @_event
    end

    # This function return the event name.
    def event_name
      @_event.name
    end

    # This function return the event payload.
    def event_payload
      @_event.payload
    end

    # This class contain the list of settings for the handler.
    class << self

      # This function sets the query update function for the handler.
      def to_update_queries(&block)
        define_method('_update_queries', &block)
      end

      # This function sets the manage event function for the handler.
      def to_manage_event(&block)
        define_method('_manage_event', &block)
      end

    end

  end
end
