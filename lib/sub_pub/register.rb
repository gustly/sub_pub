require "singleton"

module SubPub
  class Register
    include Singleton

    attr_accessor :enabled, :scope, :subscriptions

    def initialize
      @enabled = default_enabled_state
      @scope = default_scope
      @subscriptions = []
      super
    end

    def default_enabled_state
      true
    end

    def default_scope
      "sub_pub"
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
        full_topic = scoped(topic).full_topic

        ActiveSupport::Notifications.publish(full_topic, payload, &block)
      end

      def scoped(topic)
        ScopedTopic.new(topic, instance.scope)
      end

      def subscribe(*args, &block)
        topic = args.first

        options = {
          scoped_topic: ScopedTopic.new(topic, instance.scope),
          action: block
        }

        Subscription.subscribe(options).tap do |subscription|
          instance.subscriptions << subscription
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
