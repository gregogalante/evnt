# frozen_string_literal: true

# Dependencies:
# - AuthenticationMailer class used to send email to users.

module Authentication
  # Handler to manage the request recover password event.
  class RequestRecoverPasswordHandler < ApplicationHandler

    to_manage_event do
      # send mail to user
      AuthenticationMailer.request_recover_password(
        event_payload[:email],
        event_payload[:security_token]
      ).deliver_now!
    end

  end
end
