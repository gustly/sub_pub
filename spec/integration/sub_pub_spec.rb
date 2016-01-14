require 'spec_helper'

describe SubPub do
  include_context "a fake active record result"
  include_context "a fake active record user"

  describe "initial state" do
    it "defaults enabled to true" do
      SubPub::Register.instance.enabled = nil
      SubPub.enabled?.should be true
    end
  end

  describe "#enable" do
    it "enables SubPub" do
      SubPub.disable
      SubPub.enable
      SubPub.enabled?.should be true
    end
  end

  describe "#disable" do
    it "disables SubPub" do
      SubPub.disable
      SubPub.enabled?.should be false
    end
  end

  describe "#publish" do
    context "when disabled" do
      before { SubPub.disable }

      it "does not publish" do
        ActiveSupport::Notifications.should_receive(:publish).never
        SubPub.publish("my-message")
      end
    end

    context "with a set scope" do
      it "uses the configured scope" do
        payload = { :payload => 'here' }

        SubPub.scope = 'rails'

        ActiveSupport::Notifications.should_receive(:publish).with(
          "rails::my-message",
          payload
        )

        SubPub.publish("my-message", payload)
      end
    end

    context "when using the default scope" do
      it "publishes to active support using the default scope" do
        payload = { :payload => 'here' }

        ActiveSupport::Notifications.should_receive(:publish).with(
          "sub_pub::my-message",
          payload
        )

        SubPub.publish("my-message", payload)
      end
    end
  end

  describe "normal pubsub" do
    before do
      class CreateAccountSubscriber < SubPub::Subscriber
        subscribe_to("new_account_posted")

        def on_publish
          FakeActiveRecordUser.create(title: options[:title])
        end
      end
    end

    it "calls the subscriber properly" do
      FakeActiveRecordUser.all.size.should == 0
      SubPub.publish("new_account_posted", {title: 'foo'})
      FakeActiveRecordUser.all.size.should == 1
      FakeActiveRecordUser.all.first.title.should == 'foo'
    end
  end

  describe "normal pubsub with a configured scope" do
    before do
      SubPub.scope = 'foo-bar'

      class CreateAccountSubscriber < SubPub::Subscriber
        subscribe_to("new_account_posted")

        def on_publish
          FakeActiveRecordUser.create(title: options[:title])
        end
      end
    end

    it "calls the subscriber properly" do
      FakeActiveRecordUser.all.size.should == 0
      SubPub.publish("new_account_posted", {title: 'foo'})
      FakeActiveRecordUser.all.size.should == 1
      FakeActiveRecordUser.all.first.title.should == 'foo'
    end
  end

  describe 'wildcard/regex subscriber matching' do
    before do
      class SubscriberClass < SubPub::Subscriber
        subscribe_to(/event_*/)

        def on_publish
          FakeActiveRecordUser.create(title: options[:title])
        end
      end
    end

    it 'matches wild card events' do
      FakeActiveRecordUser.all.size.should == 0
      SubPub.publish("event_one", {title: 'foo'})
      FakeActiveRecordUser.all.size.should == 1
    end
  end

  describe "register subscription only once" do
    before do
      SubPub.scope = 'foo-bar'

      class CreateAccountSubscriber < SubPub::Subscriber
        subscribe_to("new_account_posted")

        def on_publish
          FakeActiveRecordUser.create(title: options[:title])
        end
      end
    end

    it "calls the subscriber properly" do
      CreateAccountSubscriber.subscribe_to("new_account_posted")
      SubPub::Register.instance.subscriptions.count.should == 1
    end
  end
end
