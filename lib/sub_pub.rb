module SubPub
  class << self
    def scope=(new_scope)
      Register.scope = new_scope
    end

    def enable
      Register.enable
    end

    def disable
      Register.disable
    end

    def enabled?
      Register.enabled?
    end

    def disabled?
      Register.disabled?
    end

    #
    #  Standardize on Pub/Sub naming
    #
    def publish(*args, &block)
      Register.publish(*args, &block)
    end

    def subscribe(*args, &block)
      Register.subscribe(*args, &block)
    end

    def unsubscribe_all
      Register.unsubscribe_all
    end
  end
end

require "sub_pub/version"
require "sub_pub/subscriber"
require "sub_pub/register"
require "sub_pub/subscription"
require "sub_pub/scoped_topic"

require "rails"
require "active_record"

require "sub_pub/active_record_subscriber"
require "sub_pub/active_record_extensions"
require "sub_pub/railtie"
