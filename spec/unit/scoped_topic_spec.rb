require 'spec_helper'

describe SubPub::ScopedTopic do
  let(:scope) { "cool_domain" }

  subject(:scoped_topic) { SubPub::ScopedTopic.new(topic, scope) }

  describe "#full_topic" do
    context "the topic is a Regexp" do
      let(:topic) { /cool_topic/ }
      specify { expect(scoped_topic.full_topic).to eq(/cool_domain::cool_topic/) }
    end

    context "the topic is not a Regexp" do
      let(:topic) { "cool_topic" }
      specify { expect(scoped_topic.full_topic).to eq("cool_domain::cool_topic") }
    end
  end

  describe "topic" do
    let(:topic) { "cool_topic" }
    specify { expect(scoped_topic.topic).to eq(topic) }
  end

end
