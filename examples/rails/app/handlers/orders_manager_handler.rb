# frozen_string_literal: true

# OrdersManagerHandler
class OrdersManagerHandler < ApplicationHandler

  on :order_created_event do
    to_update_queries do
      product = event.extras[:product] || Product.find(event.payload[:product_uuid])
      product.update(
        quantity_free: product.quantity_free - event.payload[:quantity],
        quantity_sold: product.quantity_sold + event.payload[:quantity]
      )

      Order.create(
        uuid: event.payload[:order_uuid],
        product_uuid: event.payload[:product_uuid],
        quantity: event.payload[:quantity],
        price_per_piece: product.price_per_piece
      )
    end
  end

end
