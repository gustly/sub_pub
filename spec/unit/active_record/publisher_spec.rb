require 'spec_helper'

describe SubPub::ActiveRecord::Publisher do
  let(:record) { double(:record) }
  let(:callback) { "some_callback" }

  subject(:publisher) { SubPub::ActiveRecord::Publisher.new(record, callback) }

  before do
    stub_const("SomeClassName", Class.new)
    allow(record).to receive(:class) { SomeClassName }
    allow(SubPub).to receive(:publish)
  end

  describe "publish_callback_notification" do
    let(:expected_message) { "active_record::some_class_name::some_callback" }

    it "publishes a message" do
      publisher.publish_callback_notification
      expect(SubPub).to have_received(:publish).with(expected_message, record: record)
    end
  end

  describe "publish_changed_attribute_notifications" do
    context "a before_create callback" do
      let(:callback) { 'before_create' }

      context "with attribute changes" do
        include_context "a record with changes"

        it "publishes a message" do
          publisher.publish_changed_attribute_notifications
          expect(SubPub).to have_received(:publish).with(expected_message, record: record)
        end
      end

      context "without attribute changes" do
        include_context "a record with changes"
        let(:changes) { {} }

        it "does not publish a message" do
          publisher.publish_changed_attribute_notifications
          expect(SubPub).to_not have_received(:publish)
        end
      end
    end

    context "an after_create callback" do
      let(:callback) { 'after_create' }

      context "with attribute changes" do
        include_context "a record with changes"

        it "publishes a message" do
          publisher.publish_changed_attribute_notifications
          expect(SubPub).to have_received(:publish).with(expected_message, record: record)
        end
      end

      context "without attribute changes" do
        include_context "a record with changes"
        let(:changes) { {} }

        it "does not publish a message" do
          publisher.publish_changed_attribute_notifications
          expect(SubPub).to_not have_received(:publish)
        end
      end
    end

    context "any other type of callback" do
      let(:callback) { 'after_commit' }

      context "with attribute changes" do
        include_context "a record with previous changes"

        it "publishes a message" do
          publisher.publish_changed_attribute_notifications
          expect(SubPub).to have_received(:publish).with(expected_message, record: record)
        end
      end

      context "without attribute changes" do
        include_context "a record with previous changes"
        let(:previous_changes) { {} }

        it "does not publish a message" do
          publisher.publish_changed_attribute_notifications
          expect(SubPub).to_not have_received(:publish)
        end
      end
    end
  end

end
