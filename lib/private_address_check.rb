require "ipaddr"
require "socket"

require "private_address_check/version"

module PrivateAddressCheck
  module_function

  CIDR_LIST = [
    IPAddr.new("127.0.0.0/8"),
    IPAddr.new("::1/128"),
    IPAddr.new('0.0.0.0/8'),
    IPAddr.new("169.254.0.0/16"),
    IPAddr.new("10.0.0.0/8"),
    IPAddr.new('100.64.0.0/10'),
    IPAddr.new('172.16.0.0/12'),
    IPAddr.new('192.0.0.0/24'),
    IPAddr.new('192.0.2.0/24'),
    IPAddr.new('192.88.99.0/24'),
    IPAddr.new('192.168.0.0/16'),
    IPAddr.new('198.18.0.0/15'),
    IPAddr.new('198.51.100.0/24'),
    IPAddr.new('203.0.113.0/24'),
    IPAddr.new('224.0.0.0/4'),
    IPAddr.new('240.0.0.0/4'),
    IPAddr.new('255.255.255.255'),
    IPAddr.new('64:ff9b::/96'),
    IPAddr.new('100::/64'),
    IPAddr.new('2001::/32'),
    IPAddr.new('2001:10::/28'),
    IPAddr.new('2001:20::/28'),
    IPAddr.new('2001:db8::/32'),
    IPAddr.new('2002::/16'),
    IPAddr.new('fc00::/7')
    IPAddr.new('fe80::/10'),
    IPAddr.new('ff00::/8')
  ]

  def private_address?(address)
    CIDR_LIST.any? do |cidr| 
      cidr.include?(address)
    end
  end

  def resolves_to_private_address?(hostname)
    ips = Socket.getaddrinfo(hostname, nil).map { |info| IPAddr.new(info[3]) }
    return true if ips.empty?

    ips.any? do |ip| 
      private_address?(ip)
    end
  end
end
