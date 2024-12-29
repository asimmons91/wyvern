class String
  # Check if string is lower case.
  # @return [Boolean]
  def lower?
    return false if size > 1

    ("a".."z").cover? self
  end

  # Check if string is upper case.
  # @return [Boolean]
  def upper?
    return false if size > 1

    ("A".."Z").cover? self
  end

  # Convert a CamelCase string into a snake_case string.
  # Changes '::' to '/' to convert modules into paths.
  #
  #   underscore("MyGame")          # => "my_game"
  #   underscore("MyGame::MyScene") # => "my_game/my_scene"
  #
  # @return [String]
  def underscore
    # DragonRuby doesn't have RegExp. Need to do this manually.
    # TODO: See if we can do this without array allocations?
    new_chars = []
    chars_ref = chars

    chars_ref.each_with_index do |c, i|
      if c == ":" && chars_ref[i + 1] != ":"
        new_chars << "/"
      end

      if c.upper?
        new_chars << if i == 0
          c.downcase!
        else
          "_#{c.downcase!}"
        end
      else
        c
      end
    end

    new_chars.join
  end
end
