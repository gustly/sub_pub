module SubPub
  class ScopedTopic
    def initialize(topic, scope)
      @topic = topic
      @scope = scope
    end

    def full_topic
      "#{@scope}::#{@topic}"
    end

    def topic
      @topic
    end
  end
end
