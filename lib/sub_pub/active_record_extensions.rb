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
    end

    private

    def notify_pub_sub_of_active_record_callback(callback)
      message = "active_record::#{self.class.to_s.underscore}::#{callback}"
      SubPub.publish(message, record: self)
    end
  end
end
