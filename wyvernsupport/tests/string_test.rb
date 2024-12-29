require_relative "test_helper"

def test_string_upper?(_args, assert)
  assert.true! "K".upper?, "K should be true"
  assert.false! "j".upper?, "j should be false"
  assert.false! "Hello".upper?, "Hello should be false"
end

def test_string_lower?(_args, assert)
  assert.true! "m".lower?, "m should be true"
  assert.false! "L".lower?, "L should be false"
  assert.false! "jello".lower?, "jello should be false"
end

def test_string_underscore(_args, assert)
  assert.equal! "MyGame".underscore, "my_game", "MyGame should equal my_game"
  assert.equal! "MyGame::MyScene".underscore, "my_game/my_scene", "MyGame::MyScene should equal my_game/my_scene"
end
