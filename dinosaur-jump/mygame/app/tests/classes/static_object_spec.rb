class StaticTestObject < StaticObject
  SPRITE_WIDTH = 10
  SPRITE_HEIGHT = 10

  def sprite_path(is_day:)
    "sprites/t-pose/black.png"
  end

  def can_move?
    true
  end

  def damages_player?
    true
  end

  def sprite_dimensions
    {
      w: SPRITE_WIDTH,
      h: SPRITE_HEIGHT,
    }
  end
end

def test_static_object_initialization(args, assert)
  # Test default initialization
  obj = StaticTestObject.new
  assert.equal! obj.x_velocity, DEFAULT_RUNNING_SPEED, "StaticObject x_velocity should be DEFAULT_RUNNING_SPEED"
  assert.equal! obj.gravity, -1, "StaticObject default gravity should be -1"
  assert.true! obj.can_move?, "StaticObject should be able to move"
  assert.true! obj.damages_player?, "StaticObject should damage player by default"
  assert.equal! obj.sprite_number, 0, "StaticObject sprite number should be 0 by default"

  # Test custom initialization
  custom_obj = StaticTestObject.new(gravity: 100, x_velocity: -5, num_sprites: 1)
  assert.equal! custom_obj.gravity, 100, "Custom gravity should be set"
  assert.equal! custom_obj.x_velocity, -5, "Custom x_velocity should be set"
  assert.equal! custom_obj.sprite_number, 0, "Custom num_sprites should limit sprite_number to 0"
end

def test_static_object_sprite_dimensions(args, assert)
  obj = StaticTestObject.new
  dimensions = obj.sprite_dimensions
  assert.equal! dimensions[:w], StaticTestObject::SPRITE_WIDTH, "Sprite width should match constant"
  assert.equal! dimensions[:h], StaticTestObject::SPRITE_HEIGHT, "Sprite height should match constant"
end
