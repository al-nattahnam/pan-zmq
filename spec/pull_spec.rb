require 'spec_helper'

describe PanZMQ::Pull do

  describe "#new" do
    it "should be in 'unavailable' state" do
      @pull = PanZMQ::Pull.new
      @pull.state.should == :unavailable
    end
  end

  describe "#connect" do
    it "should return 'idle' when passing a valid address" do
      @pull = PanZMQ::Pull.new
      @pull.connect("tcp://127.0.0.1:5233").should == :idle
      @pull.close
    end

    it "should return false when passing an invalid address" do
      @pull = PanZMQ::Pull.new
      @pull.connect(1245).should == false
      @pull.close
    end
  end

  describe "#bind" do
    it "should be in 'idle state'" do
      @pull = PanZMQ::Pull.new
      @pull.bind "tcp://127.0.0.1:5234"
      @pull.state.should == :idle
      @pull.close
    end
  end
  #context 'when it is not binded' do
  #  it "should be in 'unavailable' state" do
  #    EM.run do
  #      @reply = MaZMQ::Reply.new
  #      @reply.state.should == :unavailable
  #      EM.stop
  #    end
  #  end
  #end

  describe "#recv_string" do
    context 'when pulling from a binded socket' do
      it "should receive the pushed message" do
        @pull = PanZMQ::Pull.new
        @push = PanZMQ::Push.new

        @pull.bind "tcp://127.0.0.1:5235"
        @push.connect "tcp://127.0.0.1:5235"
        
        @pull.recv_string(ZMQ::DONTWAIT).should == ""

        @push.send_string("request")

        @pull.recv_string.should == "request"

        @pull.close
        @push.close
      end
    end
  end

  describe "#receive" do
    context 'when pulling from a binded socket' do
      it "should receive the pushed message" do
        @pull = PanZMQ::Pull.new
        @push = PanZMQ::Push.new

        @pull.bind "tcp://127.0.0.1:5235"
        @push.connect "tcp://127.0.0.1:5235"
        
        @push.send_string("request")
        @push.send_string("request2")
        @push.send_string("request3")

        order = 0
        @pull.on_receive { |msg|
          case order
            when 0
              msg.should == "request"
            when 1
              msg.should == "request2"
            when 2
              msg.should == "request3"
              @pull.close
              @push.close
          end
          order += 1
        }
        @pull.recv_string
      end
    end
  end

  #  it "should change its state" do
  #    EM.run do
  #      @reply = MaZMQ::Reply.new
  #      @request = MaZMQ::Request.new

  #      @reply.bind :tcp, '127.0.0.1', 5235
  #      @request.connect :tcp, '127.0.0.1', 5235

  #      @reply.state.should == :idle
  #      @request.send_string("request")

  #      @reply.on_read { |msg|
  #        @reply.state.should == :reply
  #        @reply.send_string("response")
  #        @reply.state.should == :idle
  #      }
  #      @request.on_read { |msg|
  #        @reply.close
  #        @request.close
  #        EM.stop
  #      }
  #    end
  #  end
  #end
end
