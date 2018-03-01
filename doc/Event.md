# Event

Events represtents something that it's already happened on the system. They are used to save on a persistent data structure what happends.

Every event has three informations:

- The **name** is an unique identifier of the event.
- The **attributes** are the list of attributes required from the event to be saved.
- The **handlers** are a list of handler objects which will be notified when the event is completed.

Every event has also a single function used to write the event information on the data structure.

## Structure

An example of event should be:

```ruby
class OrderCreatedEvent < Evnt::Event

    name_is :order_created

    attributes_are :order_uuid, :product_uuid, :quantity

    handlers_are [
        ProductHandler.new,
        UserNotifierHandler.new
    ]

    to_write_event do
        # save event on database
        Event.create(
            name: name,
            payload: payload
        )
    end

end
```

## Usage

### Basic usage

An example of event usage should be:

```ruby
event = OrderCreatedEvent.new(
    order_uuid: SecureRandom.uuid,
    product_uuid: params[:product_uuid],
    quantity: params[:quantity]
)

puts event.name # -> :create_order
puts event.attributes # -> [:order_id, :user_id, :product_id, :quantity]
puts event.payload # -> { order_uuid: 1, product_uuid: 534, quantity: 10, evnt: { timestamp: 2017010101, name: 'order_created' } }
```

The event payload should contain all event attributes and a reserved attributes "evnt" used to store the event timestamp and the event name.

### Advanced usage

It's possible to give datas to the event without save them on the event payload, to do this you shuld only use a key with "_" as first character. An example should be:

```ruby
event = OrderCreatedEvent.new(
    order_uuid: SecureRandom.uuid,
    product_uuid: params[:product_uuid],
    quantity: params[:quantity],
    _total_price: params[:quantity] * @product.price
)

puts event.payload # -> { order_uuid: 1, product_uuid: 534, quantity: 10, evnt: { timestamp: 2017010101, name: 'order_created' } }
puts event.extras # -> { total_price: 50 }
```

Sometimes you need to reload an old event to notify handlers to re-build queries from events. To initialize a new event object with the payload of an old event you can pass the old event payload to the event constructor:

```ruby
events = Event.where(name: 'order_created')
reloaded_event = OrderCreatedEvent.new(events.sample.payload)

puts reloaded_event.reloaded? # -> true
```

## Options

Options permits to change the way to work of the event. Options can be defined on the event initialization or as default inside the event class.

Set default options inside the event:

```ruby
class OrderCreatedEvent < Evnt::Event
    default_options silent: true
end
```

Set options on event initialization:

```ruby
event = OrderCreatedEvent.new(
    order_uuid: SecureRandom.uuid,
    product_uuid: params[:product_uuid],
    quantity: params[:quantity],
    _options: {
        silent: true
    }
)
```

### Silent option

The silent option permit to initialize a new event witout the notification of its handler. This option can be used for tests or for specific use cases.
