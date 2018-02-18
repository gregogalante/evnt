# frozen_string_literal: true

# CreateOrderCommand
class CreateOrderCommand < ApplicationCommand

  validates :product_uuid, type: :string, presence: true, blank: false
  validates :quantity, type: :integer, presence: true

  to_initialize_events do
    OrderCreatedEvent.new(
      order_uuid: SecureRandom.uuid,
      product_uuid: params[:product_uuid],
      quantity: params[:quantity]
    )
  end

end
