# Evnt

[![Gem Version](https://badge.fury.io/rb/evnt.svg)](https://badge.fury.io/rb/evnt)

CQRS and Event Driven Development architecture for Ruby projects.

- [Installation](#installation)
- [Structure](#structure)
  - [Command](https://github.com/ideonetwork/evnt/blob/master/doc/Command.md)
  - [Event](https://github.com/ideonetwork/evnt/blob/master/doc/Event.md)
  - [Handler](https://github.com/ideonetwork/evnt/blob/master/doc/Handler.md)
- [Rails integration](https://github.com/ideonetwork/evnt/blob/master/doc/RailsIntegration.md)
- [Development](#development)

Full class documentation here: https://ideonetwork.github.io/evnt/

## Installation

To use the gem you need to add it on your Gemfile

Latest version
```ruby
gem 'evnt', git: 'https://github.com/ideonetwork/evnt'
```

Legacy version
```ruby
gem 'evnt'
```

## Structure

Evnt is developed to be used over all kinds of projects and frameworks (like Ruby on Rails or Sinatra), so it contains only three types of entities:

- [Command](https://github.com/ideonetwork/evnt/blob/master/doc/Command.md)
- [Event](https://github.com/ideonetwork/evnt/blob/master/doc/Event.md)
- [Handler](https://github.com/ideonetwork/evnt/blob/master/doc/Handler.md)

Every entity is a simple class that should be extended to structure your awesome project.

## Development

To update the documentation run:

```console

rdoc --op docs

```
