# Handler

Handlers are used to listen one or more events and run tasks after their execution.

Every handler event management has two steps to execute:

- The **queries update** which updates temporary data structures used to read datas.
- The **manage event** code which run other tasks like mailers, parallel executions ecc.

An example of handler shuould be:

```ruby
class ProductHandler < Evnt::Handler

  on :order_created do

    to_update_queries do
      # update product quantity
      product = Product.find_by(uuid: event.payload[:product_uuid])
      product.update(quantity: product.quantity - event.payload[:quantity])
    end

    to_manage_event do
      # this block is called only for not reloaded events
    end

  end

end
```

The execution of **to_update_queries** block runs after every events initialization.
The execution of **to_manage_event** block runs only for not reloaded events initialization.

Sometimes you need to run some code to manage only reloaded events. To run code only for reloaded events you can use the **to_manage_reloaded_event** block:

```ruby
class ProductHandler < Evnt::Handler

  on :create_order do

    to_manage_reloaded_event do
      # this block is called only for reloaded events
    end

  end

end
```