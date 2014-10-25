require 'spec_helper'

describe SubPub do
  include_context "a fake active record result"
  include_context "a fake active record user"

  describe "after create" do
    before do
      class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
        subscribe_to(FakeActiveRecordUser, 'after_create', :title, :body)

        def on_publish
          FakeActiveRecordResult.create
        end
      end
    end

    it "successfully calls through to the subscriber" do
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create(title: "hey guys")
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create(title: "hey guys", body: "nice talking to you")


      FakeActiveRecordResult.count.should == 1
    end
  end

  describe "after commit" do
    before do
      class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
        subscribe_to(FakeActiveRecordUser, 'after_commit', :title, :body)

        def on_publish
          FakeActiveRecordResult.create
        end
      end
    end

    it "successfully calls through to the subscriber" do
      FakeActiveRecordResult.count.should == 0
      fake_user = FakeActiveRecordUser.create

      fake_user.update_attributes(title: "ABC")
      fake_user.update_attributes(body: "XYZ")
      FakeActiveRecordResult.count.should == 0

      fake_user.update_attributes(body: "words", title: "blah")
      FakeActiveRecordResult.count.should == 1

      fake_user.update_attributes(body: "things", title: "stuff", pizza: "cheese")


      FakeActiveRecordResult.count.should == 2
    end
  end

  describe "after commit on create" do
    before do
      class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
        subscribe_to(FakeActiveRecordUser, 'after_commit_on_create', :title, :body)

        def on_publish
          FakeActiveRecordResult.create
        end
      end
    end

    it "successfully calls through to the subscriber" do
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create(title: "hey guys")
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create(title: "hey guys", body: "nice talking to you")


      FakeActiveRecordResult.count.should == 1
    end
  end

  describe "after commit on update" do
    before do
      class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
        subscribe_to(FakeActiveRecordUser, 'after_commit_on_update', :title, :body)

        def on_publish
          FakeActiveRecordResult.create
        end
      end
    end

    it "successfully calls through to the subscriber" do
      FakeActiveRecordResult.count.should == 0
      fake_user = FakeActiveRecordUser.create

      fake_user.update_attributes(title: "ABC")
      fake_user.update_attributes(body: "XYZ")
      FakeActiveRecordResult.count.should == 0

      fake_user.update_attributes(body: "words", title: "blah")
      FakeActiveRecordResult.count.should == 1

      fake_user.update_attributes(body: "things", title: "stuff", pizza: "cheese")


      FakeActiveRecordResult.count.should == 2
    end
  end

  describe "before create" do
    before do
      class FakeActiveRecordUserSubscriber < SubPub::ActiveRecord::Subscriber
        subscribe_to(FakeActiveRecordUser, 'before_create', :title, :body)

        def on_publish
          record.fake_active_record_results.build(title: 'fooz')
        end
      end
    end

    it "successfully calls through to the subscriber" do
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create(title: "hey guys")
      FakeActiveRecordResult.count.should == 0

      FakeActiveRecordUser.create(title: "hey guys", body: "nice talking to you")
      FakeActiveRecordResult.count.should == 1
    end
  end
end

