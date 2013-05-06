require "rubygems"
require "open-uri"
require "set"

require "minitest/autorun"
require "minitest/pride"

require_relative "servers"
require_relative "haproxy"

describe "Round-Robin Cluster" do
  before do
    @servers = [
      FakeServer.start(8001, "app-1"),
      FakeServer.start(8002, "app-2"),
      FakeServer.start(8003, "app-3"),
    ]
    @haproxy = HAProxy.start("haproxy.cfg")

    sleep(0.1) # Give everybody a moment to boot
  end

  it "removes downed servers from the cluster" do
    @servers[1].stop
    sleep(1) # Let haproxy discover that node is down
    responses = 25.times.map { open("http://localhost:8000").read }
    Set.new(responses).must_equal(Set.new(["app-1", "app-3"]))
  end

  it "distributes requests between the three servers" do
    responses = 25.times.map { open("http://localhost:8000").read }
    Set.new(responses).must_equal(Set.new(["app-1", "app-2", "app-3"]))
  end

  after do
    @haproxy.stop
    @servers.each(&:stop)

    sleep(0.1) # Give everybody a moment to stop
  end
end