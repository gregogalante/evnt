# Evnt

CQRS and Event Driven Development architecture for Ruby projects.

- [Structure](#structure)
  - [Command](#command)
  - [Event](#event)
  - [Handler](#handler)

## Structure

Evnt is developed to be used over all kinds of projects and frameworks (like Ruby on Rails or Sinatra), so it contains only three types of entities:

- Command
- Event
- Handler

### Command

Commands are used to run single tasks on the system. It's like a controller on an MVC architecture without the communication with the client.

Every command has three steps to execute:

- The params validation which validates the parameters used to run the command.
- The logic validation which checks the command can be executed in compliance with the system rules.
- The event intialization which initializes an event object used to save the command.

An example of command should be:

```ruby
class CreateOrderCommand < Evnt::Command

  to_validate_params do
    # check params presence
    throw 'User should be present' unless params[:user_id]
    throw 'Product should be present' unless params[:product_id]
    throw 'Quantity should be present' unless params[:quantity]

    # check quantity is valid
    throw 'Quantity should be positive' if params[:quantity] < 1
  end

  to_validate_logic do
    @user = User.find_by(id: params[:user_id])
    @product = Product.find_by(id: params[:product_id])

    # check user exist
    throw 'The user does not exist' unless @user

    # check product exist
    throw 'The product does not exist' unless @product

    # check quantity exist for the product
    throw 'The requested quantity is not available' if @product.quantity < params[:quantity]

    # check user has money to buy the product
    throw 'You do not have enought money' if @user.money < @product.price * params[:quantity]
  end

  to_initialize_events do
    # generate order id
    order_id = SecureRandom.uuid

    # initialize event
    begin
      CreateOrderEvent.new(
        order_id: order_id,
        user_id: @user.id,
        product_id: @product.id,
        quantity: params[:quantity],
        _user: @user,
        _product: @product
      )
    rescue
      throw 'Sorry, there was an error', code: 500
    end
  end

end
```

An example of command usage should be:

```ruby
command = CreateOrderCommand.new(
  user_id: 128,
  product_id: 534,
  quantity: 10
)

if command.completed?
  puts 'Command completed'
  puts command.params # -> { user_id: 128, product_id: 534, quantity: 10 }
else
  puts command.errors # array of hashes with a { message, code } structure
  puts command.error_messages # array of error messages
  puts command.error_codes # array of error codes
end
```

It's also possible to use throw method inside the command to raise an exception with the option **exception: true**. An example of usage should be:

```ruby
begin
  command = CreateOrderCommand.new(
    user_id: 128,
    product_id: 534,
    quantity: 10,
    _options: {
      excption: true
    }
  )
rescue => e
  puts e
end
```

### Event

Events are used to save on a persistent data structure what happends on the system.

Every event has three informations:

- The **name** is an unique identifier of the event.
- The **attributes** are the list of attributes required from the event to be saved.
- The **handlers** are a list of handler objects which will be notified when the event is completed.

Every event has also a single function used to write the event information on the data structure.

An example of event should be:

```ruby
class CreateOrderEvent < Evnt::Event

  name_is :create_order

  attributes_are :order_id, :user_id, :product_id, :quantity

  handlers_are [
    ProductHandler.new,
    UserNotifierHandler.new
  ]

  to_write_event do
    # save event on database
    Event.create(name: name, payload: payload)
  end

end
```

An example of event usage should be:

```ruby
event = CreateOrderEvent.new(
  order_id: order_id,
  user_id: @user.id,
  product_id: @product.id,
  quantity: params[:quantity]
)

puts event.name # -> create_order
puts event.attributes # -> [:order_id, :user_id, :product_id, :quantity]
puts event.payload # -> { order_id: 1, user_id: 128, product_id: 534, quantity: 10, evnt: { timestamp, name } }
```

The event payload should contain all event attributes and a reserver attributes "evnt" used to store the event timestamp and the event name.

It's also possible to give datas to the event without save them on the event payload, to do this you shuld only use a key with "_" first character. An example should be:

```ruby
event = CreateOrderEvent.new(
  order_id: order_id,
  user_id: @user.id,
  product_id: @product.id,
  quantity: params[:quantity],
  _total_price: params[:quantity] * @product.price
)

puts event.payload # -> { order_id: 1, user_id: 128, product_id: 534, quantity: 10 }
puts event.extras # -> { _total_price: 50 }
```

After the execution of the **to_write_event** block the event object should notify all its handlers.

Sometimes you need to reload an old event to notify handlers to re-build queries from events. To initialize a new event object with the payload of an old event you can pass the old event payload to the event constructor:

```ruby
events = Event.where(name: 'create_order')
reloaded_event = CreateOrderEvent.new(events.sample.payload)

puts reloaded_event.reloaded? # -> true
```

### Handler

Handlers are used to listen one or more events and run tasks after their execution.

Every handler event management has two steps to execute:

- The queries update which updates temporary data structures used to read datas.
- The manage event code which run other tasks like mailers, parallel executions ecc.

An example of handler shuould be:

```ruby
class ProductHandler < Evnt::Handler

  on :create_order do

    to_update_queries do
      # update product quantity
      product = event.extras[:_product]
      product.update(quantity: product.quantity - event[:quantity])
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
