module SubPub
  class Subscriber
    attr_reader :options
    alias :payload :options

    def initialize(options)
      @options = options
    end

    def self.subscribe_to(topic_name)
      klass = self

      @subscription = SubPub.subscribe(topic_name) do |topic, options|
        publish(klass.new(options))
      end
    end

    def self.publish(subscription)
      subscription.on_publish
    end

    def self.subscription
      @subscription
    end

    def self.topic
      @subscription.topic
    end

    def on_publish
      raise "Please define an on_publish method for #{self.class.name}"
    end
  end
end
