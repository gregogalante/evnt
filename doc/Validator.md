# Validator

The validator is an helper class used from commands to normalize and validates parameters.

## Usage

```ruby

validation = Evnt::Validator.new('hello world', presence: true, type: :string)

puts validation.passed? # -> true
puts validation.value # -> 'my value'
```

## Default options

### - Presence

The **presence** option should check that the value is nil or not.

Examples:

```ruby
Evnt::Validator.new(nil, presence: true).passed? # -> false
Evnt::Validator.new('', presence: true).passed? # -> true
Evnt::Validator.new('hello world', presence: true).passed? # -> true
Evnt::Validator.new(nil, presence: false).passed? # -> true
Evnt::Validator.new('', presence: false).passed? # -> false
Evnt::Validator.new('hello world', presence: false).passed? # -> false
```

### - Type

The **type** option should check that the value has a specific type or can be normalized to that type.

The default supported types are **boolean, string, integer, symbol, float, hash, array, date, datetime, time**.

Examples:

```ruby
# Normal usage
Evnt::Validator.new(true, type: :boolean).passed? # -> true
Evnt::Validator.new('hello world', type: :string).passed? # -> true
Evnt::Validator.new(34, type: :integer).passed? # -> true

# Normalization usage
validation = Evnt::Validator.new(234, type: :string)
validation.passed? # -> true
validation.value # -> '234'
validation = Evnt::Validator.new('true', type: :boolean)
validation.passed? # -> true
validation.value # -> true

# Nil usage
validation = Evnt::Validator.new(nil, type: :string)
validation.passed? # -> true
validation.value # -> nil
```

That type option can be also used to theck that the value belongs to a custom class. In this case you should pass the type option value as a string.

Examples:

```ruby
user = User.new
Evnt::Validator.new(user, type: 'User').passed? # -> true
```

## Custom options

Custom options are options that should be used only with specific value types.

### Global options

#### - In

```ruby
Evnt::Validator.new(1, type: :integer, in: [1, 2, 3]).passed? # -> true
Evnt::Validator.new(1, type: :integer, in: [2, 3]).passed? # -> false
```

#### - Out

```ruby
Evnt::Validator.new(1, type: :integer, out: [1, 2, 3]).passed? # -> false
Evnt::Validator.new(1, type: :integer, in: [2, 3]).passed? # -> true
```

### String options

#### - Blank

```ruby
Evnt::Validator.new('', type: :string, blank: false).passed? # -> false
Evnt::Validator.new('hello world', type: :string, blank: false).passed? # -> true
Evnt::Validator.new('', type: :string, blank: true).passed? # -> true
Evnt::Validator.new('hello world', type: :string, blank: true).passed? # -> false
```

#### - Length

```ruby
Evnt::Validator.new('a', type: :string, length: 1).passed? # -> true
Evnt::Validator.new('a', type: :string, length: 4).passed? # -> false
```

### Number options

Number options are used for integer and float types.

#### - Min

```ruby
Evnt::Validator.new(3, type: :integer, min: 1).passed? # -> true
Evnt::Validator.new(3, type: :integer, min: 4).passed? # -> false
```

#### - Max

```ruby
Evnt::Validator.new(3, type: :integer, max: 1).passed? # -> false
Evnt::Validator.new(3, type: :integer, max: 4).passed? # -> true
```