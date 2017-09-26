# frozen_string_literal: true

require 'evnt'
require_relative '../events/basic_event'

# BasicCommand.
class BasicCommand < Evnt::Command

  to_validate_params do
    stop 'Name should be present' if params[:name].nil? || params[:name] == ''
  end

  to_validate_logic do
    stop 'Name should be foobar' if params[:name] != 'foobar'
  end

  to_initialize_events do
    BasicEvent.new(name: params[:name])
  end

end
