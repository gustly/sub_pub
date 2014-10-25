module SubPub
  module ActiveRecord
    class Publisher

      def initialize(record, callback)
        @record = record
        @callback = callback
      end

      def publish_callback_notification
        publish_notification(callback_notification)
      end

      def publish_changed_attribute_notifications
        notification = changes_notification
        publish_notification(notification) if notification
      end

      private

      attr_reader :record, :callback

      def publish_notification(message)
        SubPub.publish(message, record: record)
      end

      def callback_notification
        "active_record::#{record.class.to_s.underscore}::#{callback}"
      end

      def changes_notification
        return unless record_changes.keys.size > 0
        callback_notification.tap do |name|
          record_changes.keys.sort.each { |attribute| name << "::#{attribute}" }
        end
      end

      def record_changes
        /(before|after)_create/.match(callback) ? record.changes : record.previous_changes
      end

    end
  end
end
