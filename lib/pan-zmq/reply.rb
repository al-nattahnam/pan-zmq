module PanZMQ
  class Reply
    include PanZMQ::Socket

    def initialize
      @socket_type = ZMQ::REP
      super
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
