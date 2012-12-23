require 'spec_helper'

describe SubPub::Subscriber do
  before do
    class Bazero < SubPub::Subscriber
      subscribe_to('foo_bar_topic')
    end
  end

  context "subscriber" do
    subject do
      Bazero
    end

    it { should subscribe_to_topic('foo_bar_topic') }
  end

  describe "#topic_name" do
    it "returns the name of the topic sent to subscribe_to" do
      Bazero.new.topic_name.should == 'foo_bar_topic'
    end
  end
end
