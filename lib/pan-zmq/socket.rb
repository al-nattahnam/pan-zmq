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
    end

    def socket
      @socket
    end

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

    def kill
      @alive = false
    end

    def close
      kill
      @socket.close if not closed?
    end
    
    def closed?
      (@socket && @socket.socket) ? false : true
    end

    def addresses
      @addresses
    end

    def send_string(msg)
      @socket.send_string(msg) == 0 ? true : false
    end

    def recv_string(flags=0)
      return false if not @alive
      flags #||= ZMQ::DONTWAIT
      msg = ''
      @socket.recv_string(msg, flags)
      if defined?(@receive_block)
        #begin
          @receive_block.call(msg)
        #end while @messages.size > 0
      end
      return msg
    end

    # Returns the ZMQ socket type
    #
    # @return [Fixnum] which can be one of ZMQ::REP, ZMQ::REQ, ZMQ::PUSH, ZMQ::PULL socket types contant values
    #def socket_type
    #  @socket_type
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
