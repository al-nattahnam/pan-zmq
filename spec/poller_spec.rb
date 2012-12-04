require 'spec_helper'

describe PanZMQ::Poller do

  describe "#instance" do
    it "should have an empty list of sockets" do
      PanZMQ::Poller.instance.instance_variable_get("@sockets").should == []
    end
  end

  describe "#register" do
    it "should return 'idle' when passing a valid address" do
      @pull = PanZMQ::Pull.new
      @pull.bind("tcp://127.0.0.1:5233")
      
      PanZMQ::Poller.instance.instance_variable_get("@sockets").should == []

      @pull.register

      PanZMQ::Poller.instance.instance_variable_get("@sockets").should == [@pull]

      @pull.close
    end

    #it "should return false when passing an invalid address" do
    #  @pull = PanZMQ::Pull.new
    #  @pull.connect(1245).should == false
    #  @pull.close
    #end
  end

  describe "#reset" do
    it "should empty the sockets list" do
      pull = PanZMQ::Pull.new
      pull.bind("tcp://127.0.0.1:5233")

      PanZMQ::Poller.instance.instance_variable_get("@sockets").should == []

      pull.register

      PanZMQ::Poller.instance.instance_variable_get("@sockets").should == [pull]

      PanZMQ::Poller.instance.reset

      PanZMQ::Poller.instance.instance_variable_get("@sockets").should == []

      pull.close
    end
  end

  #describe "#bind" do
  #  it "should be in 'idle state'" do
  #    @pull = PanZMQ::Pull.new
  #    @pull.bind "tcp://127.0.0.1:5234"
  #    @pull.state.should == :idle
  #    @pull.close
  #  end
  #end

  #describe "#recv_string" do
  #  context 'when pulling from a binded socket' do
  #    it "should receive the pushed message" do
  #      @pull = PanZMQ::Pull.new
  #      @push = PanZMQ::Push.new

  #      @pull.bind "tcp://127.0.0.1:5235"
  #      @push.connect "tcp://127.0.0.1:5235"
  #      
  #      @pull.recv_string(ZMQ::NOBLOCK).should == ""

  #      @push.send_string("request")

  #      @pull.recv_string.should == "request"

  #      @pull.close
  #      @push.close
  #    end
  #  end
  #end

  #describe "#receive" do
  #  context 'when pulling from a binded socket' do
  #    it "should receive the pushed message" do
  #      @pull = PanZMQ::Pull.new
  #      @push = PanZMQ::Push.new

  #      @pull.bind "tcp://127.0.0.1:5235"
  #      @push.connect "tcp://127.0.0.1:5235"
  #      
  #      @push.send_string("request")
  #      @push.send_string("request2")
  #      @push.send_string("request3")

  #      order = 0
  #      @pull.on_receive { |msg|
  #        case order
  #          when 0
  #            msg.should == "request"
  #          when 1
  #            msg.should == "request2"
  #          when 2
  #            msg.should == "request3"
  #            @pull.close
  #            @push.close
  #        end
  #        order += 1
  #      }
  #      @pull.recv_string
  #    end
  #  end
  #end

  after(:each) do
    PanZMQ::Poller.instance.reset
  end
end
