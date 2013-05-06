class HAProxy
  def self.start(config_file)
    new(config_file).tap(&:start)
  end

  def initialize(config_file)
    @config_file = config_file
  end

  def start
    @pid = Process.fork do
      Kernel.exec("haproxy -q -f #{@config_file}")
    end
  end

  def stop
    Process.kill(:TERM, @pid)
  end
end