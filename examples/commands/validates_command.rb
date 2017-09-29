# frozen_string_literal: true

require 'evnt'
require_relative '../events/basic_event'

# ValidatesCommand.
class ValidatesCommand < Evnt::Command

  validates :string, type: :string, presence: true, blank: false
  validates :boolean_false, type: :boolean, presence: true
  validates :boolean_true, type: :boolean, presence: true
  validates :integer, type: :integer, presence: true
  validates :symbol, type: :symbol, presence: true
  validates :array, type: :array, presence: true
  validates :hash, type: :hash, presence: true
  validates :float, type: :float, presence: true
  validates :custom, type: 'Custom', presence: true

  to_validate_params {}

  to_validate_logic {}

  to_initialize_events {}

end
