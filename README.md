# PrivateAddressCheck

[![CI](https://github.com/jtdowney/private_address_check/actions/workflows/ci.yml/badge.svg)](https://github.com/jtdowney/private_address_check/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/jtdowney/private_address_check/badges/gpa.svg)](https://codeclimate.com/github/jtdowney/private_address_check)

Checks if a URL or hostname would cause a request to a private network (RFC 1918). This is useful in preventing attacks like [Server Side Request Forgery](https://cwe.mitre.org/data/definitions/918.html).

## Requirements

- Ruby >= 2.4

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'private_address_check'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install private_address_check

## Usage

```ruby
require "private_address_check"

PrivateAddressCheck.private_address?("8.8.8.8") # => false
PrivateAddressCheck.private_address?("10.10.10.2") # => true
PrivateAddressCheck.private_address?("127.0.0.1") # => true
PrivateAddressCheck.private_address?("172.16.2.10") # => true
PrivateAddressCheck.private_address?("192.168.1.10") # => true
PrivateAddressCheck.private_address?("fd00::2") # => true
PrivateAddressCheck.resolves_to_private_address?("github.com") # => false
PrivateAddressCheck.resolves_to_private_address?("localhost") # => true

require "private_address_check/tcpsocket_ext"
require "net/http"
require "uri"

Net::HTTP.get_response(URI.parse("http://192.168.1.1")) # => attempts connection like normal

PrivateAddressCheck.only_public_connections do
  Net::HTTP.get_response(URI.parse("http://192.168.1.1"))
end
# => raises PrivateAddressCheck::PrivateConnectionAttemptedError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jtdowney/private_address_check. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Security

If you've found a security issue in `private_address_check`, please reach out to @jtdowney via email to report.

### Time of check to time of use

A library like `private_address_check` is going to be easily susceptible to attacks like [time of check to time of use](https://en.wikipedia.org/wiki/Time_of_check_to_time_of_use). DNS entries with a TTL of 0 can trigger this case where the initial resolution is a public address by the subsequent resolution is a private address. There are some possible defenses and workarounds:

- Use the TCPSocket extension in this library which checks the address the socket uses. This is most useful if your system is built on native Ruby like Net::HTTP.
- Use a feature like the `resolve` capability in curl and [curb](https://www.rubydoc.info/github/taf2/curb/Curl/Easy#resolve=-instance_method) to force the resolution to a pre-checked IP address.
- Implement your own caching DNS resolver with something like dnsmasq or unbound. These tools let you set a minimum cache time that can override the TTL of 0.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
