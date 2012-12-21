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
end
