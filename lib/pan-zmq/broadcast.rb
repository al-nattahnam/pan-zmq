module PanZMQ
  class Broadcast
    include PanZMQ::Socket
    
    def initialize
      @socket_type = ZMQ::PUB
      super
    end
  end
end
