require "singleton"

module SubPub
  class Register
    include Singleton

    attr_accessor :enabled, :scope, :subscriptions

    def initialize
      @enabled = true
      @scope = "sub_pub"
      @subscriptions = []
      super
    end

    class << self
      def scope=(new_scope)
        instance.scope = new_scope
      end

      def enable
        instance.enabled = true
      end

      def disable
        instance.enabled = false
      end

      def enabled?
        if instance.enabled.nil?
          instance.enabled = true
        end

        instance.enabled
      end

      def disabled?
        !instance.enabled
      end

      def publish(*args, &block)
        return if disabled?

        topic = args.shift
        payload = args.last

        ActiveSupport::Notifications.publish(with_scope(topic), payload, &block)
      end

      def with_scope(topic)
        "#{instance.scope}::#{topic}"
      end

      def subscribe(*args, &block)
        topic = args.first

        subscription = Subscription.new(
          topic: topic,
          scope: instance.scope,
          action: block
        )

        subscription.subscribe

        instance.subscriptions << subscription

        subscription
      end

      class Subscription
        def initialize(options)
          @topic = options[:topic]
          @scope = options[:scope]
          @action = options[:action]
        end

        def subscribe
          @subscription = ActiveSupport::Notifications.subscribe(scoped_topic, @action)
        end

        def scoped_topic
          "#{@scope}::#{@topic}"
        end

        def unsubscribe
          ActiveSupport::Notifications.unsubscribe("#{@scope}::#{@topic}")
        end

        def topic
          @topic
        end
      end

      def unsubscribe_all
        instance.subscriptions.each do |subscription|
          subscription.unsubscribe
        end

        instance.subscriptions = []
      end
    end
  end
end
