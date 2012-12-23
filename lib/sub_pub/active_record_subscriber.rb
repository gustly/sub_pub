module SubPub
  module ActiveRecord
    class Subscriber < SubPub::Subscriber
      def self.subscribe_to(class_instance, callback_name)
        @class_instance = class_instance
        @callback_name = callback_name
        super("active_record::#{@class_instance.to_s.underscore}::#{@callback_name}")
      end

      def self.model_name
        @class_instance.to_s
      end

      def self.callback_name
        @callback_name
      end

      def callback_name
        self.class.callback_name
      end

      def model_name
        self.class.model_name
      end

      def record
        options[:record]
      end
    end
  end
end
