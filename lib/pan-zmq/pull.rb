module PanZMQ
  class Pull
    def initialize
      @socket = PanZMQ.context.socket ZMQ::PULL
      @socket.setsockopt(ZMQ::LINGER, 0)
      @messages = []
      @alive = true

      set_fiber
    end

    def set_fiber
      @fiber = Fiber.new { |origin, block|
        while (@socket.recv_strings(@messages) == 0 and @alive)
          block.call(@messages)
          #yield @messages
        end

        origin.transfer
      }
      self
    end

    def receive(&block)
      @fiber.transfer(Fiber.current, block)
    end

    def kill
      @alive = false
    end

    def connect(params)
      @socket.connect params
    end

    def bind(params)
      @socket.bind params
    end

    #def receive(&block)
    #  while (@socket.recv_strings(@messages) == 0 and @alive)
    #    yield @messages
    #  end
    #end

    def close
      kill
      @socket.close
    end
  end
end
