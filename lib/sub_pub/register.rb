require "singleton"

module SubPub
  class Register
    include Singleton

    attr_accessor :enabled

    def initialize
      @enabled = true
      super
    end

    class << self
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

        ActiveSupport::Notifications.publish(*args, &block)
      end

      def subscribe(*args, &block)
        ActiveSupport::Notifications.subscribe(*args, &block)
      end
    end
  end
end
