require_relative "test_helper"

class SceneTestActor < WyvernScene::Actor
  attr_accessor :foo
  attr_reader :add_called, :remove_called

  def on_added
    @add_called = true
  end

  def on_removed
    super
    @remove_called = true
  end
end

class SceneTestScene < WyvernScene::Scene
  attr_reader :enter_called, :exit_called

  def on_enter
    @enter_called = true
  end

  def on_exit
    super
    @exit_called = true
  end

  def tick(args)
    super
    args.state.scene_ticked = true
  end
end

class SceneTestStage < WyvernScene::Stage
  attr_reader :boot_called

  def initialize
    @boot_called = false
    super
  end

  def on_boot
    @boot_called = true
    add_scene SceneTestScene
  end
end

def test_scene_on_enter(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene

  assert.true! stage.current_scene.enter_called, "Scene on enter not called"
end

def test_scene_on_exit(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.on_shutdown

  assert.true! stage.current_scene.exit_called, "Scene on exit not called"
end

def test_scene_add_actor(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.current_scene.add_actor SceneTestActor, key: :test

  assert.true! stage.current_scene.actors[:test].add_called, "Actor add not called"
end

def test_scene_add_actor_args(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.current_scene.add_actor SceneTestActor, key: :test, foo: "bar"

  assert.equal! stage.current_scene.actors[:test].foo, "bar", "Actor param doesn't match"
end

def test_scene_remove_actor(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.current_scene.add_actor SceneTestActor, key: :test

  actor = stage.current_scene.get_actor :test
  stage.current_scene.remove_actor :test

  assert.true! actor.remove_called, "Actor on remove not called"
  assert.equal! stage.current_scene.actors.length, 0, "Actor wasn't removed"
end

def test_scene_get_actor(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.current_scene.add_actor SceneTestActor, key: :test

  assert.true! !stage.current_scene.get_actor(:test).nil?, "Actor wasn't found"
  assert.true! stage.current_scene.get_actor(:fake).nil?, "Fake Actor was found"
end

def test_scene_get_actor!(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.current_scene.add_actor SceneTestActor, key: :test

  assert.true! !stage.current_scene.get_actor!(:test).nil?, "Actor wasn't found"
  begin
    stage.current_scene.get_actor! :fake
  rescue WyvernScene::ActorNotFoundError => e
    assert.true! e.is_a?(WyvernScene::ActorNotFoundError), "Scene raised wrong error"
  end
end

def test_scene_has_actor(_args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.current_scene.add_actor SceneTestActor, key: :test

  assert.true! stage.current_scene.has_actor?(:test), "Scene doesn't have test actor"
  assert.false! stage.current_scene.has_actor?(:fake), "Scene has a fake Actor"
end

def test_scene_tick(args, assert)
  stage = SceneTestStage.new
  stage.go_to_scene SceneTestScene
  stage.current_scene.add_actor SceneTestActor, key: :test

  stage.tick args

  assert.true! args.state.scene_ticked, "Scene didn't tick"
end
