require_relative "test_helper"

def test_string_upper?(args, assert)
  assert.true! "K".upper?
  assert.true! "j".lower?
end
