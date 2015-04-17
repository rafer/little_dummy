require "thin"

Thin::Logging.silent = true

module LittleDummy
  class Cluster

    def self.start
      yield(new)

      sleep(0.1)

      puts "Started (ctl-c to shutdown)"

      sleep
    end

    def initialize
      @servers = []

      Signal.trap("INT") do
        @servers.each(&:stop)
        exit
      end
    end

    def server(*args)
      @servers << Server.start(*args)
    end
  end

  class Server
    attr_accessor :options, :server, :pid

    def self.start(*args)
      new(*args).tap(&:start)
    end

    def initialize(options = {} )
      self.options = options
      self.server = Thin::Server.new(host, port, app)
    end

    def start
      self.pid = Process.fork do
        puts "PID #{Process.pid}: Starting server on #{host}:#{port}"
        server.start
      end
    end

    def stop
      Process.kill(:TERM, pid) if pid
      pid = nil
    end

    def app
      app = proc do |*|
        begin
          [ code.call, {}, [ body.call ] ]
        rescue Exception => e
          puts "#{e.exception.class} #{e.message}"
          puts e.messages.join("\n")
        end
      end

      Rack::CommonLogger.new(app, Logger.new(STDOUT))
    end

    def host
      options.fetch(:host, "0.0.0.0")
    end

    def port
      options.fetch(:port, 8000)
    end

    def code
      if options[:code].respond_to?(:call)
        options[:code]
      else
        lambda { options[:code] }
      end
    end

    def body
      case options[:body]
      when Proc
        return options[:body]
      when NilClass
        return lambda { "response from port #{port}" }
      else
        return lambda { options[:body] }
      end
    end
  end
end
