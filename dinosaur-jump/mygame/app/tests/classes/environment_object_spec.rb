def test_environment_object_initialization(args, assert)
  # Test default initialization
  env_obj = EnvironmentObject.new
  assert.equal! env_obj.gravity, 0, "EnvironmentObject gravity should be 0 by default"
  assert.true! env_obj.can_move?, "EnvironmentObject should be able to move"
  assert.false! env_obj.damages_player?, "EnvironmentObject should not damage player"

  # Test custom initialization
  custom_env_obj = EnvironmentObject.new(x: 100, x_velocity: -10)
  assert.equal! custom_env_obj.x, 100, "Custom x should be set"
  assert.equal! custom_env_obj.x_velocity, -10, "Custom x_velocity should be set"
  assert.equal! custom_env_obj.gravity, 0, "Custom gravity should be ignored and remain 0" # gravity is overridden in initialize
end

def test_environment_object_calc_movement(args, assert)
  env_obj = EnvironmentObject.new(x: 0, x_velocity: -5)
  env_obj.calc
  assert.equal! env_obj.x, -5, "EnvironmentObject should move by x_velocity"
  assert.equal! env_obj.y, 0, "EnvironmentObject y position should remain constant (no gravity effect)"

  # Test with positive velocity
  env_obj_forward = EnvironmentObject.new(x: 0, x_velocity: 5)
  env_obj_forward.calc
  assert.equal! env_obj_forward.x, 5, "EnvironmentObject should move forward with positive x_velocity"

  # Test with can_move? returning false
  # To avoid redefining the class, we'll create a mock object that behaves like EnvironmentObject
  # but with can_move? returning false.
  mock_env_obj = EnvironmentObject.new(x: 0, x_velocity: -5)
  def mock_env_obj.can_move?
    false
  end
  mock_env_obj.calc
  assert.equal! mock_env_obj.x, 0, "EnvironmentObject should not move if can_move? is false"
end
