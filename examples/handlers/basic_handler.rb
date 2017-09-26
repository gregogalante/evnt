# frozen_string_literal: true

require 'evnt'

# BasicHandler.
class BasicHandler < Evnt::Handler

  on :basic do
    to_manage_event do
      puts "#{event.name} managed!"
    end
  end

end
