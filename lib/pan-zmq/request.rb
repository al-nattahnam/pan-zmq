module PanZMQ
  class Request
    include PanZMQ::Socket
    
    def initialize
      @socket_type = ZMQ::REQ
      super
    end
  end
end
