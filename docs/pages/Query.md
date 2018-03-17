# Query

Query classes are used to contain database queries used by the system to retrieve data for the clients.
Queries should contain only class method.

An example of query should be:

```ruby
class ProductsQuery < Evnt::Query

  def self.with_producer_informations
    # ...
  end

end

products = ProductsQuery.with_producer_informations
```

The query class does not contain any magic and it is only used as a subclass for specific database interfaces classes.

## QueryActiverecord

QueryActiverecord is a subclass of Query that contains helpers used to manage queries on Rails Activerecord classes.

An example of usage should be:

```ruby
class ProductsQuery < Evnt::QueryActiverecord

  def self.with_producer_informations
    Product.all.joins(
      'INNER JOIN producers ON products.producer_uuid = producers.uuid'
    ).select(
      'products.*, producers.name AS producer_name'
    )
  end

end

products = ProductsQuery.with_producer_informations
```
