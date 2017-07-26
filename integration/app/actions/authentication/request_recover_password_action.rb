# frozen_string_literal: true

# Dependencies:
# - Queries::User model to get the list of saved users.
# - JWT gem to generate a security token.

module Authentication
  # Action to manage users requests to recover the password.
  class RequestRecoverPasswordAction < Evnt::Action

    to_validate_params do
      # check params presence
      throw 'Email should be present' if params[:email].blank?
    end

    to_validate_logic do
      # find user on query user
      @user = Queries::User.find_by(email: params[:email])
      throw 'User not found for this email' unless @user
    end

    to_initialize_events do
      # generate security token
      payload = {}
      payload[:exp] = 1.days.from_now.to_i
      payload[:token_type] = 'recover_password'
      payload[:user_uuid] = @user.uuid
      security_token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
      # initialize event
      Authentication::RequestRecoverPasswordEvent.new(
        email: params[:email],
        security_token: security_token
      )
    end

  end
end
