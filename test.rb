require "bundler"

Bundler.require

require_relative "servers"
require_relative "haproxy"

FakeServer.start(8001, "app-1")
FakeServer.start(8002, "app-2")
FakeServer.start(8003, "app-3")

haproxy = HAProxy.start("haproxy.cfg")

