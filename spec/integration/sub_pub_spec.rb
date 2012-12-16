require 'spec_helper'

describe SubPub do
  with_model :FakeActiveRecordUser do
    table do |t|
      t.string :title
    end

    model do
      has_many :fake_active_record_results
    end
  end

  with_model :FakeActiveRecordResult do
    table do |t|
      t.string :title
      t.integer :fake_active_record_user_id
    end
  end

  describe "initial state" do
    it "defaults enabled to true" do
      SubPub::Register.instance.enabled = nil
      SubPub.enabled?.should be_true
    end
  end

  describe "#enable" do
    it "enables SubPub" do
      SubPub.disable
      SubPub.enable
      SubPub.enabled?.should be_true
    end
  end

  describe "#disable" do
    it "disables SubPub" do
      SubPub.disable
      SubPub.enabled?.should be_false
    end
  end

  describe "#publish" do
    context "when disabled" do
      before { SubPub.disable }

      it "does not publish" do
        ActiveSupport::Notifications.should_receive(:publish).never
        SubPub.publish
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

  describe "active record configuration" do
    describe "after create" do
      before do
        class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
          subscribe_to(FakeActiveRecordUser, 'after_create')

          def on_publish
            FakeActiveRecordResult.create
          end
        end
      end

      it "successfully calls through to the subscriber" do
        FakeActiveRecordResult.all.size.should == 0
        FakeActiveRecordUser.create
        FakeActiveRecordResult.all.size.should == 1
      end
    end

    describe "after commit" do
      before do
        class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
          subscribe_to(FakeActiveRecordUser, 'after_commit')

          def on_publish
            FakeActiveRecordResult.create
          end
        end
      end

      it "successfully calls through to the subscriber" do
        FakeActiveRecordResult.all.size.should == 0
        FakeActiveRecordUser.create
        FakeActiveRecordResult.all.size.should == 1
      end
    end

    describe "before create" do
      before do
        class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
          subscribe_to(FakeActiveRecordUser, 'before_create')

          def on_publish
            record.fake_active_record_results.build(title: 'fooz')
          end
        end
      end

      it "successfully calls through to the subscriber" do
        FakeActiveRecordResult.all.size.should == 0
        FakeActiveRecordUser.create
        FakeActiveRecordResult.all.size.should == 1
      end
    end
  end
end
