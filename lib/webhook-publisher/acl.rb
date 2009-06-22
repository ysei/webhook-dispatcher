
require "ipaddr"

class WebHookPublisher::Acl
  def initialize
    @list = []
  end

  def self.to_ipaddr(ipaddr)
    case ipaddr
    when :all   then IPAddr.new("0.0.0.0/0")
    when String then IPAddr.new(ipaddr)
    when IPAddr then ipaddr
    else raise(ArgumentError, "invalid IP address")
    end
  end

  def size
    return @list.size
  end

  def add_allow(ipaddr)
    @list << [:allow, self.class.to_ipaddr(ipaddr)]
    return self
  end

  def add_deny(ipaddr)
    @list << [:deny, self.class.to_ipaddr(ipaddr)]
    return self
  end

  def allow?(ipaddr)
    result = true

    @list.each { |type, network|
      if network.include?(ipaddr)
        result =
          case type
          when :allow then true
          when :deny  then false
          else raise("BUG")
          end
      end
    }

    return result
  end

  def deny?(ipaddr)
    return !self.allow?(ipaddr)
  end
end