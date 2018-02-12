# frozen_string_literal: true

module UsersCommands

  module Authentication

    # LoginCommand
    class LoginCommand < ApplicationCommand

      validates :name, type: :string

    end

  end

end
