def test_background_initialization(args, assert)
  # Test default initialization
  bg = Background.new
  assert.equal! bg.y, GROUND_LEVEL, "Background should initialize at GROUND_LEVEL"
  assert.equal! bg.x_velocity, DEFAULT_RUNNING_SPEED + 5, "Background x_velocity should be DEFAULT_RUNNING_SPEED + 5"
  assert.equal! bg.gravity, 0, "Background gravity should be 0"
  assert.true! bg.can_move?, "Background should be able to move"
  assert.false! bg.damages_player?, "Background should not damage player"

  # Test custom initialization
  custom_bg = Background.new(y: 100, x_velocity: -10)
  assert.equal! custom_bg.y, 100, "Custom y should be set"
  assert.equal! custom_bg.x_velocity, -10, "Custom x_velocity should be set"
end

def test_background_sprite_path(args, assert)
  bg = Background.new
  bg.sprite_number = 0 # Ensure a consistent sprite number for testing
  assert.equal! bg.sprite_path(is_day: true), "sprites/misc/background/day/0.png", "Day sprite path should be correct"
  assert.equal! bg.sprite_path(is_day: false), "sprites/misc/background/night/0.png", "Night sprite path should be correct"
end

def test_background_calc_movement(args, assert)
  bg = Background.new(x: 0, x_velocity: -5)
  bg.calc
  assert.equal! bg.x, -5, "Background should move by x_velocity"
  assert.equal! bg.y, GROUND_LEVEL, "Background y position should remain constant (no gravity effect)"

  # Test with positive velocity
  bg_forward = Background.new(x: 0, x_velocity: 5)
  bg_forward.calc
  assert.equal! bg_forward.x, 5, "Background should move forward with positive x_velocity"
end
