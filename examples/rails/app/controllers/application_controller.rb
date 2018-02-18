class ApplicationController < ActionController::Base
  def create_order
    command = CreateOrderCommand.new(
      product_uuid: params[:product_uuid],
      quantity: params[:quantity]
    )

    unless command.completed?
      render json: { result: false, errors: command.errors }
      return
    end

    render json: { result: true }
  end
end
