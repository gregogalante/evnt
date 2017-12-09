# frozen_string_literal: true

# This file contains temporary tests used for development.

require 'spec_helper'

class MyEvent < Evnt::Event

  name_is :my_event

  attributes_are :foo, :bar

end

class MyEvent2 < Evnt::Event

  name_is :my_event_2

  attributes_are :foo, :bar

end

class MyHandler < Evnt::Handler

  on :my_event do
    to_update_queries do
      puts 'my_event to_update_queries'
    end

    to_manage_event do
      puts 'my_event to_manage_event'
    end
  end

  on :my_event_2 do
    to_update_queries do
      puts 'my_event_2 to_update_queries'
    end

    to_manage_event do
      puts 'my_event_2 to_manage_event'
    end
  end

end

RSpec.describe 'Usage' do
  it 'should call the correct event management with multiple events' do
    my_event = MyEvent.new(foo: 'foo', bar: 'bar')
    my_handler = MyHandler.new

    my_handler.notify(my_event)
  end
end
