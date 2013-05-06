require "thin"
require "thread"

Thin::Logging.silent = true

class FakeServer
  attr_reader :port, :response, :server

  def self.start(*args)
    new(*args).tap(&:start)
  end

  def initialize(port, response)
    @port     = port
    @response = [response]
    @server   = Thin::Server.new("0.0.0.0", port, app)
  end

  def start
    @pid = Process.fork do
      server.start
    end
  end

  def stop
    Process.kill(:TERM, @pid) if @pid
    @pid = nil
  end

  def app
    proc { |env| [200, {}, response] }
  end
end
