module SubPub
  module ActiveRecordExtensions
    extend ActiveSupport::Concern

    included do
      ['before_create', 'after_create', 'after_commit'].each do |callback|
        class_eval "
          #{callback} do
            notify_pub_sub_of_active_record_callback('#{callback}')
          end
        "
      end

      [:create, :update, :destroy].each do |callback|
        class_eval "
          after_commit(on: callback) do
            notify_pub_sub_of_active_record_callback('after_commit_on_#{callback.to_s}')
          end
        "
      end
    end

    private

    def notify_pub_sub_of_active_record_callback(callback)
      publish_callback_notification(callback)
      publish_changed_attribute_notifications(callback)
    end

    def publish_callback_notification(callback)
      message = "active_record::#{self.class.to_s.underscore}::#{callback}"
      publish_notification(message)
    end

    def publish_changed_attribute_notifications(callback)
      message = case callback
                when /(before|after)_create/
                  changes_message(callback)
                when /after_commit/
                  previous_changes_message(callback)
                end

      publish_notification(message) if message
    end

    def changes_message(callback)
      return unless changes.keys.size > 0
      message = "active_record::#{self.class.to_s.underscore}::#{callback}".tap do |name|
        changes.keys.sort.each { |attribute| name << "::#{attribute}" }
      end
    end

    def previous_changes_message(callback)
      return unless previous_changes.keys.size > 0
      message = "active_record::#{self.class.to_s.underscore}::#{callback}".tap do |name|
        previous_changes.keys.sort.each { |attribute| name << "::#{attribute}" }
      end
    end

    def publish_notification(message)
      SubPub.publish(message, record: self)
    end

  end
end
