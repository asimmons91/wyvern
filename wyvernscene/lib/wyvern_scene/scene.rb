module WyvernScene
  class Scene
    # @!parse extend Helpers::Keyable::ClassMethods
    include Helpers::Keyable

    # Parent Stage instance
    # @return [WyvernScene::Stage]
    attr_reader :stage

    # Underlying hash of added Actor instances
    # @return [Hash]
    attr_reader :actors

    def initialize(stage)
      @stage = stage
      @actors = {}
    end

    # Add an Actor to the Scene.
    # By default, actors can be added multiple times and will have a generated :id given to them.
    #
    #   class MyScene < WyvernScene::Scene
    #     def on_added
    #       # Minion isn't unique and can be added multiple times with each one being it's own instance
    #       add_actor(Minion)
    #       add_actor(Minion)
    #
    #       # The Boss is unique and can be referenced by it's key
    #       add_actor(Boss, key: :boss)
    #
    #       # The Player is unique and will have :hp and :mp passed to the Actor
    #       add_actor(Player, key: :player, hp: 100, mp: 100)
    #     end
    #   end
    #
    # @param [Class<WyvernScene::Actor>] klass Actor class to add
    # @return [WyvernScene::Actor]
    def add_actor(klass, **params)
      if (actor_key = params[:key])
        # TODO: copy the params instead if mutating them causing issues
        params.delete :key
      end

      id = actor_key || gen_actor_id
      inst = klass.new scene: self, id: id, **params
      @actors[id] = inst
      inst.on_added
      inst
    end

    # Remove an Actor from the Scene.
    # @param [WyvernScene::Actor, Symbol, Integer] key
    # @return [void]
    def remove_actor(key)
      id = parse_actor_key key
      if (actor = @actors[id])
        actor.on_removed
        @actors.delete id
      end
    end

    # Get a specific Actor by :id or unique :key
    # @param [WyvernScene::Actor, Symbol, Integer] key
    # @return [WyvernScene::Actor, nil]
    def get_actor(key)
      id = parse_actor_key key
      @actors[id]
    end

    # Get a specific Actor by :id or unique :key
    # Raises an error if not found
    # @return [WyvernScene::Actor]
    def get_actor!(key)
      if (actor = get_actor(key))
        actor
      else
        raise ActorNotFoundError.new key
      end
    end

    # Check if the Scene has a specific Actor added
    # @param [WyvernScene::Actor, Symbol, Integer] key
    # @return [Boolean]
    def has_actor?(key)
      id = parse_actor_key key
      @actors.has_key? id
    end

    # Main tick handler for the Scene
    # @param [GTK::Args] args
    # @return [void]
    def tick(args)
      @actors.each_value { |a| a.tick args }
    end

    # On Enter lifecycle hook. Runs once when the Stage changes to to this scene.
    #
    #   class MyScene < WyvernScene::Scene
    #     def on_enter
    #       add_actor(Player)
    #       add_actor(Enemy)
    #     end
    #   end
    #
    # @return [void]
    def on_enter
    end

    # On Exit lifecycle hook. Runs once when the Stage changes to another scene or exists.
    #
    #   class MyScene < WyvernScene::Scene
    #     def on_exit
    #       my_cleanup_helper_method()
    #     end
    #   end
    #
    # @return [void]
    def on_exit
    end

    private

    # @return[Integer]
    def gen_actor_id
      @id_counter ||= 0
      @id_counter += 1
    end

    # @param [WyvernScene::Actor, Symbol, Integer]
    # @return [Symbol, Integer]
    def parse_actor_key(key)
      if key.is_a?(Integer) || key.is_a?(Symbol)
        key
      elsif key.is_a? Actor
        key.id
      else
        raise InvalidActorIdError.new key
      end
    end
  end
end
