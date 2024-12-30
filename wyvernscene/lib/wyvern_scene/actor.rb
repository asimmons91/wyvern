module WyvernScene
  class Actor
    # Primary ID of Actor instance
    # @return [Symbol, Integer]
    attr_reader :id

    # Parent Scene for Actor
    # @return [WyvernScene::Scene]
    attr_reader :scene

    # Underlying Hash of added Behavior instances
    # @return [Hash]
    attr_reader :behaviors

    # @param [WyvernScene::Scene] scene
    # @param [Symbol, Integer] id
    def initialize(scene:, id:, **params)
      @scene = scene
      @id = id
      @behaviors = {}
      mass_assign params if params
      yield self if block_given?
    end

    # Add a Behavior to this Actor
    # Any keyword args are passed to the Behavior.
    # A block can be used for custom Behavior configuration as well.
    #
    #   add_behavior(Inputs)
    #
    #   # Behavior added with extra args
    #   add_behavior(Position, x: 100, y: 100)
    #
    #   # Behavior added with block
    #   add_behavior(Sprite) do |s|
    #     s.path = "sprites/player.png"
    #   end
    #
    # @param [Class<WyvernScene::Behavior>] klass
    # @return [WyvernScene::Behavior]
    def add_behavior(klass, **params, &block)
      inst = klass.new self, **params, &block
      @behaviors[inst.key] = inst
      inst.on_added
      inst
    end

    # Get Behavior instance from the Actor
    # @param [Class<WyvernScene::Behavior>] klass
    # @return [WyvernScene::Behavior, nil]
    def get_behavior(klass)
      @behaviors[klass.key]
    end

    # Get Behavior instance from the Actor
    # Raises an error if not found.
    # @param [Class<WyvernScene::Behavior>] klass
    # @return [WyvernScene::Behavior]
    def get_behavior!(klass)
      if (behavior = @behaviors[klass.key])
        behavior
      else
        raise BehaviorNotFoundError.new self, klass
      end
    end

    # Check if Actor has specific Behavior added
    # @param [Class<WyvernScene::Behavior>] klass
    # @return [Boolean]
    def has_behavior?(klass)
      @behaviors.has_key? klass.key
    end

    # Main tick handler for the Actor
    # @param [GTK::Args] args
    # @return [void]
    def tick(args)
      @behaviors.each_value { |b| b.tick args }
    end

    # Destroy this Actor instance
    # @return [void]
    def destroy!
      scene.remove_actor id
    end

    # On Added lifecycle hook. Runs once when the Actor is added to a Scene
    #
    #   class MyActor < WyvernScene::Actor
    #     def on_added
    #       add_behavior(Sprite)
    #     end
    #   end
    #
    # @return [void]
    def on_added
    end

    # On Removed lifecycle hook. Runs once when the Actor is removed from a Scene
    #
    #   class MyActor <WyvernScene::Actor
    #     def on_removed
    #       super
    #       my_custom_clean_method()
    #     end
    #   end
    #
    # @return [void]
    def on_removed
      @behaviors.each_value { |b| b.on_removed }
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
