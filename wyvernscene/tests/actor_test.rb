require_relative "test_helper"

class ActorTestBehavior < WyvernScene::Behavior
  attr_accessor :foo
end

class ActorTestOtherBehavior < WyvernScene::Behavior
end

class ActorTestActor < WyvernScene::Actor
  attr_accessor :add_called, :remove_called, :foo

  def on_added
    super
    @add_called = true
  end

  def on_removed
    super
    @remove_called = true
  end

  def tick(args)
    super
    args.state.actor_ticked = true
  end
end

class ActorTestScene < WyvernScene::Scene
  def on_enter
    add_actor ActorTestActor, key: :actor
  end
end

class ActorTestStage < WyvernScene::Stage
  def on_boot
    add_scene ActorTestScene
    go_to_scene ActorTestScene
  end
end

def test_actor_on_added(_args, assert)
  stage = ActorTestStage.new

  assert.true! stage.current_scene.get_actor(:actor).add_called, "On added not called"
end

def test_actor_on_removed(_args, assert)
  stage = ActorTestStage.new
  actor_ref = stage.current_scene.get_actor :actor
  stage.current_scene.remove_actor :actor

  assert.true! actor_ref.remove_called, "On removed not called"
end

def test_actor_params(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.add_actor(ActorTestActor, key: :actor2, foo: "bar")

  assert.equal! stage.current_scene.get_actor(:actor2).foo, "bar", "Actor custom param not set"
end

def test_actor_add_behavior(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior ActorTestBehavior

  assert.equal! stage.current_scene.get_actor(:actor).behaviors.length, 1, "Actor Behavior not added"
end

def test_actor_add_behavior_params(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior(ActorTestBehavior, foo: "bar")

  assert.equal! stage.current_scene.get_actor(:actor).get_behavior(ActorTestBehavior).foo, "bar",
    "Actor Behavior added with incorrect params"
end

def test_actor_add_behavior_block(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior ActorTestBehavior do |a|
    a.foo = "bar"
  end

  assert.equal! stage.current_scene.get_actor(:actor).get_behavior(ActorTestBehavior).foo, "bar",
    "Actor Behavior added with incorrect params"
end

def test_actor_get_behavior(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior ActorTestBehavior

  assert.false! stage.current_scene.get_actor(:actor).get_behavior(ActorTestBehavior).nil?, "Actor Behavior is nil"
  assert.true! stage.current_scene.get_actor(:actor).get_behavior(ActorTestOtherBehavior).nil?, "Other Behavior isn't nil"
end

def test_actor_get_behavior!(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior ActorTestBehavior

  begin
    stage.current_scene.get_actor(:actor).get_behavior! ActorTestOtherBehavior
  rescue WyvernScene::BehaviorNotFoundError => e
    assert.true! e.is_a?(WyvernScene::BehaviorNotFoundError), "Actor get behavior threw wrong error"
  end
end

def test_actor_has_behavior(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.get_actor(:actor).add_behavior ActorTestBehavior

  assert.true! stage.current_scene.get_actor(:actor).has_behavior?(ActorTestBehavior), "Actor doesn't have expected behavior"
  assert.false! stage.current_scene.get_actor(:actor).has_behavior?(ActorTestOtherBehavior), "Actor has unexpected behavior"
end

def test_actor_destroy!(_args, assert)
  stage = ActorTestStage.new
  stage.current_scene.get_actor(:actor).destroy!

  assert.equal! stage.current_scene.actors.length, 0, "Actor wasn't destroyed"
end

def test_actor_tick(args, assert)
  stage = ActorTestStage.new
  stage.tick args

  assert.true! args.state.actor_ticked, "Actor didn't tick"
end
