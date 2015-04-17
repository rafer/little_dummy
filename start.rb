require "bundler"

require_relative "little_dummy"

LittleDummy::Cluster.start do |cluster|
  cluster.server(:port => 8001, :code => 200, :body => "works\n")
  cluster.server(:port => 8002, :code => 404, :body => "your bad\n")
  cluster.server(:port => 8003, :code => 503, :body => "our bad\n")
end
