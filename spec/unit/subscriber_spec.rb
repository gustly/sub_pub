require 'spec_helper'

describe SubPub::Subscriber do
  class FooBar < SubPub::Subscriber
  end

  describe ".topic" do
    it "sets up a subscription" do
      FooBar.class_eval do
        subscribe_to("foo")
      end

      FooBar.topic.should == 'foo'
    end
  end

  describe ".subscription" do
    it "should be the result of the subscribe" do
      subscription = stub

      SubPub.should_receive(:subscribe).with('topic-name') { subscription }

      FooBar.class_eval do
        subscribe_to("topic-name")
      end

      FooBar.subscription.should be(subscription)
    end
  end

  describe ".publish" do
    it "notifies the subscription of the publish event" do
      subscription = double
      subscription.should_receive(:on_publish)
      FooBar.publish(subscription)
    end
  end

  describe "#on_publish" do
    it "warns developers that they need to implement the interface" do
      expect {FooBar.new({}).on_publish}.to raise_error(/Please define/)
    end
  end

  describe "payload" do
    let(:payload) { double }
    it "has a payload" do
      FooBar.new(payload).payload.should == payload
    end

    it "has options" do
      FooBar.new(payload).options.should == payload
    end
  end
end
