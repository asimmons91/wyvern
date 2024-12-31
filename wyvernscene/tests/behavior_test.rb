require_relative "test_helper"

class BehaviorTestBehavior < WyvernScene::Behavior
  def tick(args)
    args.state.behavior_ticked = true
  end
end

class BehaviorTestOtherBehavior < WyvernScene::Behavior
  attr_accessor :foo, :add_called, :remove_called

  def on_added
    super
    @add_called = true
  end

  def on_removed
    super
    @remove_called = true
  end
end

class BehaviorTestActor < WyvernScene::Actor
  def on_added
    add_behavior BehaviorTestBehavior
  end
end

class BehaviorTestScene < WyvernScene::Scene
  def on_enter
    add_actor BehaviorTestActor, key: :actor
  end
end

class BehaviorTestStage < WyvernScene::Stage
  def on_boot
    add_scene BehaviorTestScene
    go_to_scene BehaviorTestScene
  end
end

def test_behavior_on_added(_args, assert)
  stage = BehaviorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior BehaviorTestOtherBehavior

  assert.true! stage.current_scene.get_actor(:actor).get_behavior(BehaviorTestOtherBehavior).add_called,
    "Behavior on add not called"
end

def test_behavior_on_removed(_args, assert)
  stage = BehaviorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior BehaviorTestOtherBehavior
  behavior_ref = stage.current_scene.get_actor(:actor).get_behavior(BehaviorTestOtherBehavior)
  stage.current_scene.get_actor(:actor).destroy!

  assert.true! behavior_ref.remove_called,
    "Behavior on remove not called"
end

def test_behavior_tick(args, assert)
  stage = BehaviorTestStage.new
  stage.tick args

  assert.true! args.state.behavior_ticked, "Behavior didn't tick"
end
