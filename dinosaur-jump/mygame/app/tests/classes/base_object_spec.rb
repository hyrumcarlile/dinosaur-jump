class PhysicsTestObject < BaseObject
  SPRITE_WIDTH = 10
  SPRITE_HEIGHT = 10

  def can_move?
    true
  end

  def damages_player?
    false
  end

  def sprite_path(is_day:)
    "sprites/t-pose/black.png"
  end

  # Helper to access protected/private methods if needed for testing
  def public_calc
    calc
  end
end

# 2. BaseObject Tests
def test_base_object_initialization(args, assert)
  # Test defaults
  obj = PhysicsTestObject.new
  assert.equal! obj.x, 0, "Default x should be 0"
  assert.equal! obj.gravity, -1, "Default gravity should be -1"

  # Test custom values
  obj = PhysicsTestObject.new(x: 100, gravity: -0.5)
  assert.equal! obj.x, 100, "Custom x should be set"
  assert.equal! obj.gravity, -0.5, "Custom gravity should be set"
end

def test_argument_validation_error(args, assert)
  # This tests the safety check we added to BaseObject
  begin
    PhysicsTestObject.new(x: 10, invalid_param: 999)
    assert.fail! "Should have raised ArgumentError for unknown parameter"
  rescue ArgumentError
    assert.ok!
  end
end

def test_physics_gravity_and_floor(args, assert)
  # Setup object in the air
  start_y = GROUND_LEVEL + 100
  obj = PhysicsTestObject.new(y: start_y, gravity: -1)

  # Tick 1: Velocity changes by gravity (-1), Position changes by velocity (0)
  obj.calc
  assert.equal! obj.y, start_y, "Object shouldn't move on first tick if velocity was 0"
  assert.equal! obj.y_velocity, -1, "Velocity should decrease by gravity"

  # Tick 2: Position changes by velocity (-1)
  obj.calc
  assert.equal! obj.y, start_y - 1, "Object should fall by current velocity"

  # Test Floor Collision
  # Place object right above ground moving down fast
  obj.y = GROUND_LEVEL + 1
  obj.y_velocity = -10
  obj.calc

  assert.equal! obj.y, GROUND_LEVEL, "Object should not fall below GROUND_LEVEL"
  assert.equal! obj.y_velocity, 0, "Velocity should reset to 0 when hitting ground"
end
