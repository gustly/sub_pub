require 'spec_helper'

describe "active record matchers" do
  class FakeUser
  end

  class FoozBarz < SubPub::ActiveRecord::Subscriber
    subscribe_to(FakeUser, 'after_create')
  end

  describe FoozBarz do
    it { should subscribe_to_model(FakeUser) }
    it { should subscribe_to_callback('after_create') }
  end
end
