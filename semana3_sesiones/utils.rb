#Basado en http://stackoverflow.com/questions/42566/getting-the-hostname-or-ip-in-ruby-on-rails
require 'socket'

def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end
=begin
class Class 
    def default_attr_reader(hsh) 
        hsh.each do |var, default|
            define_method(m) do 
                instance_variable_get("@#{m}") || default
            end
        end
    end
end
=end
