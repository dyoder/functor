require 'rubygems'
%w{ bacon facon }.each { |dep| require dep }
Bacon.summary_on_exit

module Kernel
  private
  def specification(name, &block)  Bacon::Context.new(name, &block) end
end

Bacon::Context.instance_eval do
  alias_method :specify, :it
end

$:.unshift "#{File.dirname(__FILE__)}/../lib"
require "functor"