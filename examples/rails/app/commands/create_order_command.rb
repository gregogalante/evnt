# frozen_string_literal: true

# CreateOrderCommand
class CreateOrderCommand < ApplicationCommand

  validates :product_uuid, type: :string, presence: true, blank: false
  validates :quantity, type: :integer, presence: true

  to_validate_logic do
    @product = Product.find_by(uuid: params[:product_uuid])
    err('product not found') && break unless @product

    product_qnt_check = @product.quantity_free >= params[:quantity]
    err('product quantity not available') && break unless product_qnt_check
  end

  to_initialize_events do
    event = OrderCreatedEvent.new(
      order_uuid: SecureRandom.uuid,
      product_uuid: params[:product_uuid],
      quantity: params[:quantity],
      _product: @product
    )

    err('command can not be completed') unless event.saved?
  end

end
