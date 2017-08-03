# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Handler do
  it 'should be initialized' do
    handler = Evnt::Handler.new
    expect(handler).not_to be nil
  end
end
