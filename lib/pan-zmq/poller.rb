require 'singleton'

module PanZMQ
  class Poller
    include Singleton

    def initialize
      @poller = ZMQ::Poller.new
      @sockets = []
    end

    def register(socket)
      @sockets.push socket
      @poller.register(socket.socket, ZMQ::POLLIN) if not socket.closed?
    end

    def unregister(socket)
      @sockets.delete socket
      @poller.deregister(socket.socket, ZMQ::POLLIN) if not socket.closed?
    end

    def reset
      @sockets.each(&:unregister)
      @poller = ZMQ::Poller.new
    end

    def poll
      @poller.poll(:blocking)
      @poller.readables.each do |socket|
        @sockets.select {|s| s.socket === socket}.each {|s|
          s.recv_string
        }
      end
      return
    end
  end
end
