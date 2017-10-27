# frozen_string_literal: true

##
# This example show the usage of the validation inside the command.
# Version: 2.1.0
##

require_relative './commands/validates_command'

# Custom Class.
# This class is used to try the custom type validator.
class Custom

  def initialize; end

end

# initialize command.
command = ValidatesCommand.new(
  string: 'foobar',
  boolean_false: false,
  boolean_true: true,
  integer: 12,
  symbol: :example,
  array: [],
  hash: {},
  float: 1.1,
  custom: Custom.new
)

# check command completed.
if command.completed?
  puts 'command completed'
else
  puts command.error_messages
end
