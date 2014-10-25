module SubPub
  module ActiveRecord
    module Extensions
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
        publisher = SubPub::ActiveRecord::Publisher.new(self, callback)
        publisher.publish_callback_notification
        publisher.publish_changed_attribute_notifications
      end

    end
  end
end
