require_relative "test_helper"

class BootStage < WyvernScene::Stage
  attr_reader :boot_called

  def initialize
    @boot_called = false
    super
  end

  def on_boot
    @boot_called = true
  end
end

def test_stage_boot(_args, assert)
  boot_stage = BootStage.new
  assert.true! boot_stage.boot_called, "on_boot hook not called"
end
