# frozen_string_literal: true

require 'test_helper'

# ApplicationEventTest.
class ApplicationEventTest < ActiveSupport::TestCase

  test 'it should be initialized' do
    event = ApplicationEvent.new
    assert_not_nil event
  end

end
