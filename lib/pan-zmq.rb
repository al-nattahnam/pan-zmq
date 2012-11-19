require 'ffi-rzmq'
require 'fiber'

require "pan-zmq/version"
require "pan-zmq/push"
require "pan-zmq/pull"

module PanZMQ
  @@context = nil
  def self.context
    # Como MaZMQ estaria funcionando siempre en EM, el proceso en el cual corre seria siempre unico, y por esa razon (repasando http://zguide.zeromq.org/page:all#Getting-the-Context-Right), usamos un unico Contexto en toda la aplicacion. Y el usuario no tiene que instanciar uno.
    @@context ||= ZMQ::Context.new
    @@context
  end
  
  def self.terminate
    @@context.terminate if @@context
  end
end