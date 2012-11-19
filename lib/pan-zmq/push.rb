module PanZMQ
  class Push
    def initialize
      @socket = PanZMQ.context.socket ZMQ::PUSH
      @socket.setsockopt(ZMQ::LINGER, 0)
    end

    def connect(params)
      @socket.connect params
    end

    def send_string(message)
      @socket.send_string(message)
    end

    def bind(params)
      @socket.bind params
    end

    def close
      @socket.close
    end
  end
end
