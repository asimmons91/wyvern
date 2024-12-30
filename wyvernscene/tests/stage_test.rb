require_relative "test_helper"

class SampleScene < WyvernScene::Scene
  attr_reader :enter_called, :exit_called

  def on_enter
    @enter_called = true
  end

  def on_exit
    super
    @exit_called = true
  end
end

class SampleStage < WyvernScene::Stage
  attr_reader :boot_called

  def initialize
    @boot_called = false
    super
  end

  def on_boot
    @boot_called = true
    add_scene SampleScene
  end
end

def test_stage_boot(_args, assert)
  stage = SampleStage.new

  assert.true! stage.boot_called, "on_boot hook not called"
end

def test_add_scene(_args, assert)
  stage = SampleStage.new

  assert.equal! stage.scenes.length, 1, "One scene not registered"
  assert.equal! stage.current_scene, nil, "Current scene is defined"
end

def test_go_to_scene_key(_args, assert)
  stage = SampleStage.new
  stage.go_to_scene :sample_scene

  assert.true! !stage.current_scene.nil?, "Current scene is nil"
  assert.equal! stage.current_scene.key, SampleScene.key, "Current scene key doesn't match"
end

def test_go_to_scene_class(_args, assert)
  stage = SampleStage.new
  stage.go_to_scene SampleScene

  assert.true! !stage.current_scene.nil?, "Current scene is nil"
  assert.equal! stage.current_scene.key, SampleScene.key, "Current scene key doesn't match"
end

def test_stage_shutdown(_args, assert)
  stage = SampleStage.new
  stage.go_to_scene SampleScene
  stage.on_shutdown

  assert.true! stage.current_scene.exit_called, "Current scene didn't exit"
end
