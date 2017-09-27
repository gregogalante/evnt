# frozen_string_literal: true

require 'evnt'
require_relative '../events/basic_event'

# ValidatesCommand.
class ValidatesCommand < Evnt::Command

  validates :name, presence: true, type: :string
  validates :surname, presence: true, type: :string

  to_validate_params do
    # this is a custom parameters validation.
    err 'Name should has three or more chars' if params[:name].length < 3
    err 'Surname should has three or more chars' if params[:surname].length < 3
  end

  to_validate_logic do
    # this is a validation about the system logic.
    err 'Name should be foobar' if params[:name] + params[:surname] != 'foobar'
  end

  to_initialize_events {}

end
