require "bundler"

require_relative "little_dummy"

LittleDummy::Cluster.start do |cluster|
  cluster.server(:port => 8001, :code => 200, :body => "D1")
  cluster.server(:port => 8002, :code => 200, :body => "D2")
  cluster.server(:port => 8003, :code => 200, :body => "D3")
end
