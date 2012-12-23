require 'spec_helper'

class Blaz < SubPub::Subscriber
  subscribe_to('fooobar')
end

describe Blaz do
  it { should subscribe_to_topic('fooobar') }
end
