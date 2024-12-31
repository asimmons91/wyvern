module WyvernScene
  class DuplicateSceneError < StandardError
  end

  class InvalidSceneKeyError < StandardError
  end

  class SceneNotFoundError < StandardError
  end

  class ActorNotFoundError < StandardError
    def initialize(key)
      super("Unable to find Actor with key #{key}")
    end
  end

  class InvalidActorIdError < StandardError
    def initialize(key)
      super("Actor key #{key} is invalid")
    end
  end

  class BehaviorNotFoundError < StandardError
    def initialize(actor, klass)
      super("Actor #{actor.id} does not have Behavior #{klass.key} attached")
    end
  end
end
