# frozen_string_literal: true

# Dependencies:
# - Queries::User model to get the list of saved users.
# - BCrypt gem to generate a crypted password.

module Authentication
  # Action to manage users signup.
  class SignupAction < ApplicationAction

    to_validate_params do
      # check params presence
      throw 'Name should be present' if params[:name].blank?
      throw 'Surname should be present' if params[:surname].blank?
      throw 'Email should be present' if params[:email].blank?
      throw 'Password should be present' if params[:password].blank?
      throw 'Repeated password should be present' if params[:password_confirmation].blank?
      # check password and password confirmation are the same
      check_psw = params[:password] == params[:password_confirmation]
      throw 'Password and repeated password should be equal' unless check_psw
    end

    to_validate_logic do
      # check no other users exist with same email
      same_users = Queries::User.where(email: params[:email])
      throw 'Email is already used' unless same_users.empty?
    end

    to_initialize_events do
      # generate uuid and password digest
      uuid = SecureRandom.uuid
      password_digest = BCrypt::Password.create(params[:password], cost: 10)
      # initialize event
      Authentication::SignupEvent.new(
        uuid: uuid,
        name: params[:name],
        surname: params[:surname],
        email: params[:email],
        password_digest: password_digest
      )
    end

  end
end
