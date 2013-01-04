module SubPub
  module Matchers
    def subscribe_to_model(expected)
      SubscribeToModel.new(expected)
    end

    def subscribe_to_callback(expected)
      SubscribeToModelCallback.new(expected)
    end

    def subscribe_to_topic(expected)
      SubscribeToTopic.new(expected)
    end

    class SubscribeToTopic
      def initialize(expected_topic)
        @expected_topic = expected_topic
      end

      def matches?(subject)
        subject.topic_name.should == @expected_topic
      end
    end

    class SubscribeToModel
      def initialize(expected)
        @expected = expected
      end

      def matches?(subject)
        subject.model_name.should == @expected.name
      end
    end

    class SubscribeToModelCallback
      def initialize(expected)
        @expected = expected
      end

      def matches?(subject)
        subject.callback_name.should == @expected
      end
    end
  end
end
