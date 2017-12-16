# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Handler do
  handler = Evnt::Handler.new

  it 'should be initialized' do
    expect(handler).not_to eq nil
  end
end
