# frozen_string_literal: true

require 'test_helper'

# ApplicationCommandTest.
class ApplicationCommandTest < ActiveSupport::TestCase

  test 'it should be initialized' do
    command = ApplicationCommand.new
    assert_not_nil command
    assert command.completed?
  end

end
