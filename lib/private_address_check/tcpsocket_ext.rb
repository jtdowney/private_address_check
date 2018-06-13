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

  EXCEPTION_WHITELIST = []

  alias_method :initialize_without_private_address_check, :initialize

  def initialize(remote_host, remote_port, local_host = nil, local_port = nil)
    begin
      initialize_without_private_address_check(remote_host, remote_port, local_host, local_port)
    rescue => e
      unless EXCEPTION_WHITELIST.include? e.class
        private_address_check! remote_host
      end

      raise
    end

    private_address_check! remote_address.ip_address
  end

  private

  def private_address_check!(address)
    return unless Thread.current[:private_address_check]
    return unless PrivateAddressCheck.resolves_to_private_address?(address)

    raise PrivateAddressCheck::PrivateConnectionAttemptedError
  end
end
