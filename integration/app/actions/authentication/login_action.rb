# frozen_string_literal: true

# Dependencies:
# - Queries::User model to get the list of saved users.
# - BCrypt gem to read a crypted password.

module Authentication
  # Action to manage users login.
  class LoginAction < Evnt::Action

    to_validate_params do
      # check params presence
      throw 'Email should be present' if params[:email].blank?
      throw 'Password should be present' if params[:password].blank?
    end

    to_validate_logic do
      # find user on query user
      @user = Queries::User.find_by(email: params[:email])
      unless @user
        throw 'User not found for this email'
        return
      end
      # check password is correct
      user_password = BCrypt::Password.new(@user.password_digest)
      throw 'Password is not correct' unless user_password == params[:password]
    end

    to_initialize_events do
      # initialize event
      Authentication::LoginEvent.new(uuid: @user.uuid)
    end

  end
end
