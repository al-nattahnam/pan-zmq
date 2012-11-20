module PanZMQ
  class Push
    include PanZMQ::Socket
    
    def initialize
      @socket_type = ZMQ::PUSH
      super
    end
  end
end
