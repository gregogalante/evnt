class ApplicationController < ActionController::Base

  def index
    @products = ProductsQuery.as_json(:with_producer)
  end

  def show
    @product = ProductsQuery.as_json(:with_producer, uuid: params[:uuid])
  end

  def create_order
    command = CreateOrderCommand.new(
      product_uuid: params[:uuid],
      quantity: params[:quantity]
    )

    if command.completed?
      redirect_to create_order_completed_path
    else
      redirect_to create_order_error_path(
        error_message: command.error_messages.to_sentence
      )
    end
  end

  def create_order_completed; end

  def create_order_error; end

end
