# Command

Commands are used to run single tasks on the system. They represent a single action that can be executed by an actor of the system.

A command can be generated with a single class that extends **Evnt::Command**:

```ruby
class CreateOrderCommand < Evnt::Command

end
```

Every command has three steps to execute:

- The parameters normalization and validation which validates the parameters used to run the command.
- The logic validation which checks the command can be executed in compliance with the system rules.
- The event intialization which initializes an event object used to save the command.

## Parameters normalizazion and validation

# TODO