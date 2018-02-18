# frozen_string_literal: true

require 'test_helper'

# ApplicationHandlerTest.
class ApplicationHandlerTest < ActiveSupport::TestCase

  test 'it should be initialized' do
    handler = ApplicationHandler.new
    assert_not_nil handler
  end

end
