module PanZMQ
  module SocketStates
    # [:unavailable, :idle, :sending, :receiving, :error]

    def self.included(base)
      base.send(:attr_reader, :state)
    end

    def initialize
      @state = :unavailable
      super
    end

    def connect(address)
      super(address) {
        if @state == :unavailable
          @state = :idle
        end
      }
    end

    def bind(address)
      super(address) {
        if @state == :unavailable
          @state = :idle
        end
      }
    end

    def send_string(msg)
      case @state
        when :idle
          @state = :sending
          super(msg)
          @state = :idle
          return @state
        else
          return :error
      end
    end
  end
end
