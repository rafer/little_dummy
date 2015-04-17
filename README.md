# LittleDummy

Test load balancing or routing config locally by firin' up some HTTP dummies locally.

## Usage

Configure start.rb:

```ruby
require "bundler"

require_relative "little_dummy"

LittleDummy::Cluster.start do |cluster|
  cluster.server(:port => 8001, :code => 200, :body => "works")
  cluster.server(:port => 8002, :code => 404, :body => "your bad")
  cluster.server(:port => 8003, :code => 503, :body => "our bad")
end
```

Then start your little dummies

    ruby start.rb

And try it out:

    $ curl localhost:8001
    works

    $ curl localhost:8002
    your bad

    $ curl localhost:8003
    our bad

## Installation

    git clone git@github.com:rafer/little_dummy.git
    cd little_dummy
    ruby start.rb
