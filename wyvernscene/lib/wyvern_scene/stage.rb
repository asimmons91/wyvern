module WyvernScene
  class Stage
    # The active Scene
    # @return [WyvernScene::Scene]
    attr_reader :current_scene

    # Underlying hash of added scene classes
    # @return [Hash]
    attr_reader :scenes

    def initialize
      @scenes = {}
      on_boot
    end

    # Add a new scene to the Stage
    # @param [Class<Scene>] klass
    # @return [void]
    def add_scene(klass)
      if @current_scene&.key == klass.key
        raise DuplicateSceneError.new "Stage already has scene with key #{klass.key}"
      end
      @scenes[klass.key] = klass
    end

    # Change the Stage's current scene
    #
    #   go_to_scene(PlayScene)
    #   go_to_scene(:play_scene)
    #
    # @param [Class<Scene>, Symbol] scene Symbol of scene key or scene class itself
    # @return [void]
    def go_to_scene(scene)
      if scene.is_a? Symbol
        key = scene
      elsif scene.is_a? Scene
        key = scene.key
      else
        raise InvalidSceneKeyError.new
      end

      unless @scenes.has_key? key
        if scene.is_a? Scene
          @scenes[key] = scene
        else
          raise SceneNotFoundError.new "Unable to find scene by key #{key}"
        end
      end

      @current_scene&.on_exit
      @current_scene = @scenes[key]
      @current_scene.on_enter
    end

    # Main tick handler for the Stage
    #
    # @param [GTK::Args] args
    # @return [void]
    def tick(args)
      @current_scene&.tick args
    end

    # On boot lifecycle hook. Runs once just after the Stage is created.
    #
    #   Class MyStage < WyvernScene::Stage
    #     def on_boot
    #       add_scene(Start)
    #       add_scene(Play)
    #       add_scene(End)
    #       go_to_scene(Start)
    #     end
    #   end
    #
    # @return [void]
    def on_boot
    end

    # On shutdown lifecycle hook. Runs once when the game exists.
    #
    #   Class MyStage < WyvernScene::Stage
    #     def on_shutdown
    #       super
    #       my_custom_cleanup_method()
    #     end
    #   end
    #
    # @return [void]
    def on_shutdown
      @current_scene&.on_exit
    end
  end
end
