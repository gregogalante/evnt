# Command

Commands are used to run single tasks on the system. They represent a single action that can be executed by an actor of the system.

A command can be generated with a single class that extends **Evnt::Command**.

```ruby
class CreateOrderCommand < Evnt::Command
end
```

Every command has three steps to execute:

- The **parameters normalization and validation** which validates the parameters used to run the command.
- The **logic validation** which checks the command can be executed in compliance with the system rules.
- The **event intialization** which initializes an event object used to save the command.

## Parameters normalizazion and validation

The first step to normalize and validate parameters is to use the default validation options coming from the **Evnt::Validator** class. These options are similar to Rails ActiveRecord validators and can be used to check the parameters type and value.

An example of validation options usage should be:

```ruby
class CreateOrderCommand < Evnt::Command
    validates :product_uuid, type: :string, presence: true, blank: false
    vaidates :quantity, type: :integer, presence: true, min: 1
end
```