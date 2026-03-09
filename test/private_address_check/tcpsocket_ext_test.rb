require "test_helper"
require "private_address_check/tcpsocket_ext"

class TCPSocketExtTest < Minitest::Test
  def test_private_address
    server = TCPServer.new(63_453)
    thread = Thread.start { server.accept }
    assert_raises PrivateAddressCheck::PrivateConnectionAttemptedError do
      PrivateAddressCheck.only_public_connections do
        TCPSocket.new("localhost", 63_453)
      end
    end
  ensure
    thread.exit if thread
  end

  def test_public_address
    connected = false
    PrivateAddressCheck.only_public_connections do
      TCPSocket.new("example.com", 80)
      connected = true
    end

    assert connected
  end

  def test_invalid_domain
    assert_raises SocketError do
      PrivateAddressCheck.only_public_connections do
        TCPSocket.new("not_a_domain", 80)
      end
    end
  end

  # Ruby 4 added an open_timeout kwarg to TCPSocket.new/open.
  # This is the same check used in https://github.com/ruby/net-http/blob/d7103a1b2c48addb22f87e8ad6713fa4e4f931c4/lib/net/http.rb#L1783
  if Socket.method(:tcp).parameters.include?([:key, :open_timeout])
    def test_public_address_with_timeout
      connected = false
      PrivateAddressCheck.only_public_connections do
        TCPSocket.new("example.com", 80, open_timeout: 30)
        connected = true
      end

      assert connected
    end
  end
end
