module SubPub
  module ActiveRecord
    class Subscriber < SubPub::Subscriber
      def self.subscribe_to(class_instance, callback)
        super("active_record::#{class_instance.to_s.underscore}::#{callback}")
      end

      def record
        options[:record]
      end
    end
  end
end
