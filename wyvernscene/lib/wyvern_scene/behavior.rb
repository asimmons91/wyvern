module WyvernScene
  class Behavior
    # @!parse extend Helpers::Keyable::ClassMethods
    include Helpers::Keyable

    # Parent Actor instance
    # @return [WyvernScene::Actor]
    attr_reader :actor

    def initialize(actor, **params)
      @actor = actor
      mass_assign params if params
      yield self if block_given?
    end

    # Generic Hash for shared state with parent Actor
    # @return [Hash]
    def state
      actor.state
    end

    # Main tick handler for the Behavior
    # @param [GTK::Args] args
    # @return [void]
    def tick(args)
    end

    def on_added
    end

    def on_removed
    end

    private

    # @param [Hash] attrs
    # @return [void]
    def mass_assign(attrs)
      attrs.each do |key, val|
        send :"#{key}=", val
      end
    end
  end
end
