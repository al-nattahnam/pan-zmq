require 'spec_helper'

describe PanZMQ::Push do

  describe "#new" do
    it "should be in 'unavailable' state" do
      @push = PanZMQ::Push.new
      @push.state.should == :unavailable
    end
  end

  describe "#connect" do
    it "should return 'idle' when passing a valid address" do
      @push = PanZMQ::Push.new
      @push.connect("tcp://127.0.0.1:5233").should == :idle
      @push.close
    end

    it "should return false when passing an invalid address" do
      @push = PanZMQ::Push.new
      @push.connect(1245).should == false
      @push.close
    end
  end

  describe "#bind" do
    it "should be in 'idle state'" do
      @push = PanZMQ::Push.new
      @push.bind "tcp://127.0.0.1:5234"
      @push.state.should == :idle
      @push.close
    end
  end

  context 'when pushing to a listening Reply' do
    it "should send a response" do
      @pull = PanZMQ::Pull.new
      @push = PanZMQ::Push.new

      @pull.bind "tcp://127.0.0.1:5235"
      @push.connect "tcp://127.0.0.1:5235"

      @pull.close
      @push.close

    end

=begin
      it "should change its state" do
        EM.run do
          @reply = MaZMQ::Reply.new
          @request = MaZMQ::Request.new

          @reply.bind :tcp, '127.0.0.1', 5235
          @request.connect :tcp, '127.0.0.1', 5235

          @request.state.should == :idle
          @request.send_string("request")
          @request.state.should == :sending

          @reply.on_read { |msg|
            @reply.send_string("response")
          }
          @request.on_read { |msg|
            @request.state.should == :idle

            @reply.close
            @request.close
            EM.stop
          }
        end
      end
=end

=begin
      context ".send_string" do
        it "should return false when trying to send before receiving a response" do
          EM.run do
            @reply = MaZMQ::Reply.new
            @request = MaZMQ::Request.new

            @reply.bind :tcp, '127.0.0.1', 5235
            @request.connect :tcp, '127.0.0.1', 5235

            @request.send_string("request").should == :sending
            @request.send_string("request").should == false

            @reply.on_read { |msg|
              @reply.send_string("response")
            }
            @request.on_read { |msg|
              @reply.close
              @request.close
              EM.stop
            }
          end
        end
      end
=end
  end

  #context "not under EM, Reply inside Thread/EM" do
  #  after(:each) do
  #    @request.close
  #    sleep 1
  #  end
  #end
end
