# frozen_string_literal: true

# OrdersManagerHandler
class OrdersManagerHandler < ApplicationHandler

  on :order_created_event do
    to_manage_event do
      puts 'New event!'
      puts event.payload
    end
  end

end
