# frozen_string_literal: true

# Dependencies:
#

module Authentication
  # Action to manage users logout.
  class LogoutAction < ApplicationAction

    to_validate_params do
      # check params presence
      throw 'Uuid should be present' if params[:uuid].blank?
    end

    to_validate_logic do
      # check session is active on sessions cache
      session_cache = Rails.cache.read(:sessions)[params[:uuid]]
      throw 'User is already logged out' unless session_cache
    end

    to_initialize_events do
      # initialize event
      Authentication::LogoutEvent.new(uuid: params[:uuid])
    end

  end
end
