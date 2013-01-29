module PanZMQ
  class Subscribe
    include PanZMQ::Socket

    def initialize
      @socket_type = ZMQ::SUB
      super
    end

    def listen(topic)
      @socket.setsockopt(ZMQ::SUBSCRIBE, topic)
    end

    def on_receive(&block)
      @receive_block = block
    end

    def register
      PanZMQ::Poller.instance.register(self)
    end

    def unregister
      PanZMQ::Poller.instance.unregister(self)
    end

  end
end
