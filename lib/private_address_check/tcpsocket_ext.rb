module PrivateAddressCheck
  PrivateConnectionAttemptedError = Class.new(StandardError)

  module_function

  def only_public_connections
    Thread.current[:private_address_check] = true
    yield
  ensure
    Thread.current[:private_address_check] = false
  end

  module TCPSocketExt
    def initialize(remote_host, remote_port, local_host = nil, local_port = nil)
      if Thread.current[:private_address_check] && PrivateAddressCheck.resolves_to_private_address?(remote_host)
        raise PrivateAddressCheck::PrivateConnectionAttemptedError
      end

      super
    end
  end
end

TCPSocket.send(:prepend, PrivateAddressCheck::TCPSocketExt)
