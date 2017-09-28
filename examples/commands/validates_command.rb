# frozen_string_literal: true

require 'evnt'
require_relative '../events/basic_event'

# ValidatesCommand.
class ValidatesCommand < Evnt::Command

  validates :string, type: :string, presence: true
  validates :boolean_false, type: :boolean, presence: true
  validates :boolean_true, type: :boolean, presence: true
  validates :integer, type: :integer, presence: true
  validates :custom, type: 'Custom', presence: true

  to_validate_params {}

  to_validate_logic {}

  to_initialize_events {}

end
