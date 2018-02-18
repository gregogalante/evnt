# frozen_string_literal: true

# OrderCreatedEvent
class OrderCreatedEvent < ApplicationEvent

  name_is :order_created_event

  attributes_are :order_uuid, :product_uuid, :quantity

  handlers_are [
    OrdersManagerHandler.new
  ]

end
