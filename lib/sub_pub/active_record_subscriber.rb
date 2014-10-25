module SubPub
  module ActiveRecord
    class Subscriber < SubPub::Subscriber
      def self.subscribe_to(class_instance, callback_name, *table_attributes)
        @class_instance = class_instance
        @callback_name = callback_name
        @table_attributes = table_attributes

        super(subscription_name)
      end

      def self.model_name
        @class_instance.to_s
      end

      def self.callback_name
        @callback_name
      end

      def self.table_attributes
        @table_attributes
      end

      def callback_name
        self.class.callback_name
      end

      def model_name
        self.class.model_name
      end

      def table_attributes
        self.class.table_attributes
      end

      def record
        options[:record]
      end

      private

      def self.subscription_name
        table_attributes.empty? ? string_subscription : regex_subscription
      end

      def self.string_subscription
        subscription_basename
      end

      def self.regex_subscription
        matcher = subscription_basename << "::"
        matcher.tap do |m|
          table_attributes.sort.each { |attribute| m << ".*(?:(#{attribute})(?:::|$))" }
        end

        Regexp.new(matcher)
      end

      def self.subscription_basename
        "active_record::#{@class_instance.to_s.underscore}::#{@callback_name}"
      end

    end
  end
end
