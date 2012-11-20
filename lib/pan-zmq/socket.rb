module PanZMQ
  module Socket

    def self.included(base)
      base.send(:include, PanZMQ::SocketStates)
    end

    def initialize
      @socket = PanZMQ::context.socket(@socket_type)
      @socket.setsockopt(ZMQ::LINGER, 0)
      
      @addresses = []
      @messages = []
      @alive = true

      #@em_reactor_running = EM.reactor_running? && EM.reactor_thread?

      set_fiber
    end

    def set_fiber
      @fiber = Fiber.new { |origin, block|
        while (@socket.recv_strings(@messages) == 0 and @alive)
          begin
            block.call(@messages.shift)
          end while @messages.size > 0
          #yield @messages
        end

        origin.transfer
      }
      self
    end

    #def em_reactor_running?
    #  @em_reactor_running
    #end

    def connect(address, &success)
      # check multiple connects for ZMQ::REQ should RoundRobin
      return false if not address.is_a? String

      @socket.connect(address)

      @addresses << address
      
      success.call

      # Retry and add callback when running under EM ?
      # so it works as on_connect { puts ""}
      # on_connection_error
    end

    def bind(address, &success)
      # check once binded should not bind anymore
      return false if not address.is_a? String

      @socket.bind(address)

      @addresses << address

      success.call
    end

    def close
      @socket.close
    end

    def addresses
      @addresses
    end

    def send_string(msg)
      @socket.send_string(msg) == 0 ? true : false
    end

    def recv_string(flags=nil)
      msg = ''
      #if @em_reactor_running
      #  flags ||= ZMQ::NOBLOCK
      #end
      if flags
        @socket.recv_string(msg, flags)
      else
        @socket.recv_string(msg)
      end
      return msg
    end

    # Returns the ZMQ socket type
    #
    # @return [Fixnum] which can be one of ZMQ::REP, ZMQ::REQ, ZMQ::PUSH, ZMQ::PULL socket types contant values
    #def socket_type
    #  @socket_type
    #end

    #def on_read(&block)
    #  return false if not @connection or block.arity != 1
    #  @connection.on_read(block)
    #end

    #def on_write(&block)
    #  return false if not @connection or block.arity != 1
    #  @connection.on_write(block)
    #end

    def identity
      arr = []
      @socket.getsockopt(ZMQ::IDENTITY, arr)
      arr[0].to_sym rescue nil
    end

    def identity=(identity)
      @socket.setsockopt(ZMQ::IDENTITY, identity.to_s)
    end
  end
end
