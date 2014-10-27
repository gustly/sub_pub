require 'spec_helper'

describe SubPub do
  include_context "a fake active record result"
  include_context "a fake active record user"

  describe "subscribing to an active record callback" do
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

    describe "after commit on create" do
      before do
        class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
          subscribe_to(FakeActiveRecordUser, 'after_commit_on_create')

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

    describe "after commit on destroy" do
      before do
        class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
          subscribe_to(FakeActiveRecordUser, 'after_commit_on_destroy')

          def on_publish
            FakeActiveRecordResult.create
          end
        end
      end

      it "successfully calls through to the subscriber" do
        FakeActiveRecordResult.all.size.should == 0
        FakeActiveRecordUser.create.destroy
        FakeActiveRecordResult.all.size.should == 1
      end
    end

    describe "after commit on update" do
      before do
        class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
          subscribe_to(FakeActiveRecordUser, 'after_commit_on_update')

          def on_publish
            FakeActiveRecordResult.create
          end
        end
      end

      it "successfully calls through to the subscriber" do
        FakeActiveRecordResult.all.size.should == 0
        fake_user = FakeActiveRecordUser.create
        fake_user.update_attributes(title: "ABC")
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
