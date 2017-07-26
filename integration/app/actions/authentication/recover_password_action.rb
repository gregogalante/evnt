# frozen_string_literal: true

# Dependencies:
# - Queries::User model to get the list of saved users.
# - JWT gem to generate a security token.

module Authentication
  # Action to manage users requests to recover the password.
  class RecoverPasswordAction < Evnt::Action

    to_validate_params do
      # check params presence
      throw 'Security token should be present' if params[:security_token].blank?
      throw 'Password should be present' if params[:password].blank?
      throw 'Repeated password should be present' if params[:password_confirmation].blank?
      # check password and password confirmation are the same
      check_psw = params[:password] == params[:password_confirmation]
      throw 'Password and repeated password should be equal' unless check_psw
    end

    to_validate_logic do
      # decode security token and check presence
      token = decode_token
      unless token
        throw 'Security token is not correct'
        return
      end
      # check token is correct
      if !token[:user_uuid] || !token[:token_type] || token[:token_type] != 'recover_password'
        throw 'Security token is not correct'
        return
      end
      # check token user exist
      @user = Queries::User.find_by(uuid: token[:user_uuid])
      unless @user
        throw 'User for the token does not exist'
        return
      end
    end

    to_initialize_events do
      # generate new password digest
      password_digest = BCrypt::Password.create(params[:password], cost: 10)
      # initialize the event
      Authentication::RecoverPasswordEvent.new(
        uuid: @user.uuid,
        password_digest: password_digest
      )
    end

    private

    # This function decodes and returns the security token value.
    def decode_token
      body = JWT.decode(params[:security_token], Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end

  end
end
