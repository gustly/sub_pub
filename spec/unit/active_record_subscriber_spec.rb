require 'spec_helper'

describe SubPub::ActiveRecord::Subscriber do
  with_model :FooBar do
    table do |t|
      t.string :title
    end
  end

  before do
    class Fooz < SubPub::ActiveRecord::Subscriber
      subscribe_to(FooBar, 'after_create')
    end

    class Bazz < SubPub::ActiveRecord::Subscriber
      subscribe_to(FooBar, 'after_create')
    end
  end

  it "returns the model name observed" do
    Fooz.model_name.should == 'FooBar'
  end

  it "returns the callback observed" do
    Bazz.callback_name.should == 'after_create'
  end

  context 'matchers' do
    subject do
      Fooz
    end

    it { should subscribe_to_model(FooBar) }
    it { should subscribe_to_callback("after_create") }
  end
end

