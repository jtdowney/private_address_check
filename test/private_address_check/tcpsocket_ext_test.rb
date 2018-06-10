require "test_helper"
require "private_address_check/tcpsocket_ext"
require "net/http"
require "uri"

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

  def test_http_request
    assert_raises PrivateAddressCheck::PrivateConnectionAttemptedError do
      PrivateAddressCheck.only_public_connections do
        Net::HTTP.get_response(URI.parse("http://192.168.1.1"))
      end
    end
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
end
