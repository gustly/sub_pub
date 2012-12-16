module SubPub
  class Subscription
    def initialize(options)
      @scoped_topic = options[:scoped_topic]
      @action = options[:action]
    end

    def self.subscribe(options)
      subscription = new(options)
      subscription.subscribe
      subscription
    end

    def subscribe
      @subscription = ActiveSupport::Notifications.subscribe(@scoped_topic.full_topic, @action)
    end

    def unsubscribe
      ActiveSupport::Notifications.unsubscribe(@scoped_topic.full_topic)
    end

    def topic
      @scoped_topic.topic
    end
  end
end
