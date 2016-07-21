require "ipaddr"
require "resolv"

require "private_address_check/version"

module PrivateAddressCheck
  module_function

  CIDR_LIST = [
    # Loopback
    IPAddr.new("127.0.0.0/8"),

    # Link Local,
    IPAddr.new("169.254.0.0/16"),

    # RFC 1918
    IPAddr.new("10.0.0.0/8"),
    IPAddr.new("172.16.0.0/12"),
    IPAddr.new("192.168.0.0/16"),

    # RFC 4193
    IPAddr.new("fc00::/7"),
  ]

  def private_address?(address)
    CIDR_LIST.any? do |cidr| 
      cidr.include?(address)
    end
  end

  def resolves_to_private_address?(hostname)
    ips = Resolv.getaddresses(hostname)
    ips.any? do |ip| 
      private_address?(ip)
    end
  end
end
