# kemal-flash2

A replacement for the existing [kemal-flash](https://github.com/neovintage/kemal-flash)
library that I created because the original was not working for me and didn't
appear to be in line to receive any updates any time soon. Like the original
library this one depends on the [kemal-session](https://github.com/kemalcr/kemal-session)
library. Note that only string values can be stored in the flash.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
    kemal:
      github: kemalcr/kemal
    kemal-session:
      github: kemalcr/kemal-session
    kemal-flash2:
      github: free-beer/kemal-flash2
   ```

2. Run `shards install`


## Usage

```crystal
require "kemal"
require "kemal-session"
require "kemal-flash2"

# Add the middleware to handle flash.
add_handler FlashHandler.new

get "/" do |env|
  env.flash["notice"] = "welcome"
end

get "/check_flash" do |env|
  env.flash["notice"]?
end
```


## Development

The flash is implemented as a piece of middleware for the Kemal system. This
middleware is in the ``FlashHandler`` class. The details of the previous requests
flash insertions are read in from a value stored in the session prior to
processing the actual request. Upon completion of the request processing the
details added to or updated in flash during the request processing are written
back out to the session store.

### Configuration

There isn't much that can be configured under this implementation except the
key used to store the flash value into the session with. You can customise that
when you set up the middleware like this...

```crystal
# Add the middleware to handle flash.
add_handler FlashHandler.new("alternative_key")
```

## Contributing

1. Fork it (<https://github.com/free-beer/kemal-flash2/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Peter Wood](https://github.com/free-beer) - creator and maintainer
