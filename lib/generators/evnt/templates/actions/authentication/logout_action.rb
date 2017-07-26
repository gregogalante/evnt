# frozen_string_literal: true

# Dependencies:
# - SessionsCache class used to write and read memory cache datas.

module Authentication
  # Action to manage users logout.
  class LogoutAction < Evnt::Action

    to_validate_params do
      # check params presence
      throw 'Uuid should be present' if params[:uuid].blank?
    end

    to_validate_logic do
      # check session is active on sessions cache
      session_cache = SessionsCache.read(params[:uuid])
      throw 'User is already logged out' unless session_cache
    end

    to_initialize_events do
      # initialize event
      Authentication::LogoutEvent.new(uuid: params[:uuid])
    end

  end
end
