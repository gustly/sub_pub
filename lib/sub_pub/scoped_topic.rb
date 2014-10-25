module SubPub
  class ScopedTopic
    attr_reader :topic

    def initialize(topic, scope)
      @topic = topic
      @scope = scope
    end

    def full_topic
      scoped_topic
    end

    private

    attr_reader :scope

    def scoped_topic
      if topic.is_a? Regexp
        /#{scope}::#{topic.source}/
      else
        "#{scope}::#{topic}"
      end
    end
  end
end
