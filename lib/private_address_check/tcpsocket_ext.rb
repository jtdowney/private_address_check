module PrivateAddressCheck
  PrivateConnectionAttemptedError = Class.new(StandardError)

  module_function

  def only_public_connections
    Thread.current[:private_address_check] = true
    yield
  ensure
    Thread.current[:private_address_check] = false
  end
end

TCPSocket.class_eval do
  alias initialize_without_private_address_check initialize

  def initialize(*args)
    initialize_without_private_address_check(*args)
    if Thread.current[:private_address_check] && PrivateAddressCheck.resolves_to_private_address?(remote_address.ip_address)
      raise PrivateAddressCheck::PrivateConnectionAttemptedError
    end
  end
end
