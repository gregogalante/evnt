# Command

Commands are used to run single tasks on the system. They represent a single action that can be executed by an actor.

A command can be generated with a single class that extends **Evnt::Command**.

```ruby
class CreateOrderCommand < Evnt::Command; end

command = CreateOrderCommand.new(foo: 'bar')
puts command.completed?
```

Every command has three steps to execute after its initialization:

- The **parameters normalization and validation** which validates the parameters used to run the command.
- The **logic validation** which checks the command can be executed in compliance with the system rules.
- The **events intialization** which initializes one or more events.

## Parameters normalization and validation

The first step to normalize and validate parameters is to use the default validation options coming from the **Evnt::Validator** class. These options are similar to Rails ActiveRecord validators and can be used to check the parameters type and normalize their value.

An example of validation options usage should be:

```ruby
class CreateOrderCommand < Evnt::Command
    # This validation should check if product_uuid parameter is not nil, is a string
    # (or can be normalized to string) and is not blank.
    validates :product_uuid, type: :string, presence: true, blank: false
    # This validation should check if quantity parmeter is not nil, is a integer
    # (or can be normalized to a integer) and is positive.
    vaidates :quantity, type: :integer, presence: true, min: 1, err: 'Custom error message'

    # ...
end
```

See the [Evnt::Validator](https://github.com/ideonetwork/evnt/blob/master/doc/Validator.md) class documentation to get the completed list of possible validations.

If you need to normalize and validate parameters manually you can also define the blocks **to_normalize_params** and **to_validate_params**. An example of manually validation should be:

```ruby
class CreateOrderCommand < Evnt::Command
    # ...

    to_normalize_params do
        params[:quantity] ||= 1
    end

    to_validate_params do
        err('product_uuid not accepted') unless params[:product_uuid]
    end

    # ...
end
```

## Logic validation

The logic validation step is used to check if the command can be executed with respect to the system logics.
The logic validation is defined with the block **to_validate_logic**. An example of logic validation should be:

```ruby
class CreateOrderCommand < Evnt::Command
    # ...

    to_validate_logic do
        product = Product.find_by(uuid: params[:product_uuid])

        unless product
            err('product_uuid not accepted')
            break
        end

        err('quantity not accepeted') if product.free_quantitity >= params[:quantity]
    end

    # ...
end
```

The err() function is used to create a command error and stop the execution of the next step. A command error is a hash object with a code and a message value that can be readed outside the command with the errors() method.

## Events initialization

The events initialization step is the last step executed by a command. It is the **to_initialize_events** block which should contain the initialization of one or more events.
An example of events initialization should be:

```ruby
class CreateOrderCommand < Evnt::Command
    # ...

    to_initialize_events do
        OrderCreatedEvent.new(
            order_uuid: SecureRandom.uuid,
            product_uuid: params[:product_uuid],
            quantity: params[:quantity]
        )
    end

    # ...
end
```

## Usage

An example of command usage should be:

```ruby
command = CreateOrderCommand.new(
    product_uuid: 534,
    quantity: 10
)

puts command.params # -> { product_id: 534, quantity: 10 }

unless command.completed?
    puts command.errors # array of hashes with a { message, code } structure
    puts command.error_messages # array of error messages
    puts command.error_codes # array of error codes
end
```

## Options

Options permits to change the way to work of the command. Options can be defined on the command initialization or as default inside the command class.

Set default options inside the command:

```ruby
class CreateOrderCommand < Evnt::Command
    default_options exceptions: true, nullify_empty_params: true
end
```

Set options on command initialization:

```ruby
command = CreateOrderCommand.new(
    user_id: 128,
    product_id: 534,
    quantity: 10,
    _options: {
        exceptions: true,
        nullify_empty_params: true
    }
)
```

### Exceptions option

Exception option permits the usage of err method inside the command to raise an exception. An example of usage should be:

```ruby
class CreateOrderCommand < Evnt::Command
    validates :product_uuid, type: :string, presence: true, blank: false, err: 'Product uuid not accepted'

    # ...
end

begin
    command = CreateOrderCommand.new(
        user_id: 128,
        quantity: 10,
        _options: {
            exceptions: true
        }
    )
rescue => e
    puts e # -> Product uuid not accepted
end
```

### Nullify empty params option

This options permits to consider nil all parameters that respond false to the empty? method. An example of usage should be:

```ruby
class CreateOrderCommand < Evnt::Command
    PRODUCTS = [1, 2, 3, 4]

    validates :product_uuid, type: :string, in: PRODUCTS, err: 'Product uuid not accepted'

    # ...
end

command = CreateOrderCommand.new(
    user_id: 128,
    product_uuid: '',
    quantity: 10,
    _options: {
        nullify_empty_params: true
    }
)

puts command.completed? # -> true
```
