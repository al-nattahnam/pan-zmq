module PanZMQ
  class Pull
    include PanZMQ::Socket

    def initialize
      @socket_type = ZMQ::PULL
      super
    end

    def receive(&block)
      @fiber.transfer(Fiber.current, block)
    end

  end
end
