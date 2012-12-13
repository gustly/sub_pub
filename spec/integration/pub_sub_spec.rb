require 'spec_helper'

describe SubPub do
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
  end

  describe "active record configuration" do
    with_model :FakeActiveRecordUser do
      table do |t|
        t.string :title
      end
    end

    with_model :FakeActiveRecordResult do
      table do |t|
        t.string :title
      end
    end

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
end
