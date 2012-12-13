module SubPub
  class ActiveRecordExtensions < Rails::Railtie
    initializer "pub sub configuration of active record extensions" do
      class ::ActiveRecord::Base
        after_create :notify_of_after_create

        private

        def notify_of_after_create
          notify_pub_sub_of_active_record_callback('after_create')
        end

        def notify_pub_sub_of_active_record_callback(callback)
          message = "active_record::#{self.class.to_s.underscore}::#{callback}"
          SubPub.publish(message, record: self)
        end
      end

      config.after_initialize do
        Dir[
          File.expand_path("app/models/pub_sub/*.rb", Rails.root)
        ].each { |file| require file }
      end
    end
  end

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
