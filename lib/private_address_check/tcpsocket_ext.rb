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

module TCPSocketExt
  def initialize(remote_host, remote_port, local_host = nil, local_port = nil)
    if Thread.current[:private_address_check]
      ip = Resolv.getaddress(remote_host)
      if PrivateAddressCheck.private_address?(ip)
        raise PrivateAddressCheck::PrivateConnectionAttemptedError
      end

      super(ip, remote_port, local_host, local_port)
    else
      super
    end
  end
end

TCPSocket.prepend(TCPSocketExt)
