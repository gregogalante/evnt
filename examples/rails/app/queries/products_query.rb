# frozen_string_literal: true

# ProductsQuery.
class ProductsQuery < ApplicationQuery

  def self.with_producer(uuid: nil)
    query = Product.all.joins(
      'INNER JOIN producers ON products.producer_uuid = producers.uuid'
    ).select(
      'products.*, producers.name AS producer_name'
    )
    query = query.find_by(uuid: uuid) if uuid

    query
  end

end
