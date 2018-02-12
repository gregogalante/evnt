# frozen_string_literal: true

module UsersEvents

  module Authentication

    # LoginEvent
    class LoginEvent < ApplicationEvent

      name_is :users_events_authentication_login_event

      attributes_are :user_uuid, :ip_address

    end

  end

end
