require 'spec_helper'

describe SubPub::Subscription do
  let(:scoped_topic) { double(:scoped_topic) }
  let(:topic) { double(:topic) }
  let(:action) { double(:action) }
  let(:active_support_subscription) { double(:active_support_subscription) }
  let(:options) do
    {
      scoped_topic: scoped_topic,
      action: action
    }
  end

  let(:subscription) { SubPub::Subscription.new(options) }

  before do
    allow(scoped_topic).to receive(:topic) { topic }
  end

  shared_context "a subscribable subscription" do
    let(:full_topic) { double(:full_topic) }

    before do
      allow(scoped_topic).to receive(:full_topic) { full_topic }
      allow(ActiveSupport::Notifications).to receive(:subscribe) { active_support_subscription }
    end
  end

  shared_examples "a method which adds a subscription" do
    specify do
      SubPub::Subscription.subscribe(options)
      expect(ActiveSupport::Notifications).to have_received(:subscribe).
        with(full_topic, action) { active_support_subscription }
    end
  end

  describe ".subscribe" do
    include_context "a subscribable subscription"
    it_behaves_like "a method which adds a subscription"
    specify do
      returned_object = SubPub::Subscription.subscribe(options)
      expect(returned_object.is_a? SubPub::Subscription).to be true
    end
  end

  describe "#subscribe" do
    include_context "a subscribable subscription"
    it_behaves_like "a method which adds a subscription"
    specify { expect(subscription.subscribe).to eq(active_support_subscription) }
  end

  describe "#unsubscribe" do
    include_context "a subscribable subscription"

    before do
      allow(ActiveSupport::Notifications).to receive(:unsubscribe)
    end

    specify do
      subscription.subscribe
      subscription.unsubscribe

      expect(ActiveSupport::Notifications).to have_received(:unsubscribe).
        with(active_support_subscription)
    end
  end

  describe "#topic" do
    specify { expect(subscription.topic).to eq(topic) }
  end

end
