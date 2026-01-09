def test_foreground_initialization(args, assert)
  # Test default initialization
  fg = Foreground.new
  assert.equal! fg.y, 0, "Foreground should initialize at 0"
  assert.equal! fg.x_velocity, DEFAULT_RUNNING_SPEED, "Foreground x_velocity should be DEFAULT_RUNNING_SPEED"
  assert.equal! fg.gravity, 0, "Foreground gravity should be 0"
  assert.true! fg.can_move?, "Foreground should be able to move"
  assert.false! fg.damages_player?, "Foreground should not damage player"
  assert.true! fg.sprite_number.between?(0, 4), "Foreground sprite number should be between 0 and 4"

  # Test custom initialization
  custom_fg = Foreground.new(y: 50, x_velocity: -15, num_sprites: 2)
  assert.equal! custom_fg.y, 50, "Custom y should be set"
  assert.equal! custom_fg.x_velocity, -15, "Custom x_velocity should be set"
  assert.true! custom_fg.sprite_number.between?(0, 1), "Custom num_sprites should limit sprite_number"
end

def test_foreground_sprite_path(args, assert)
  fg = Foreground.new
  fg.sprite_number = 0 # Ensure a consistent sprite number for testing
  assert.equal! fg.sprite_path(is_day: true), "sprites/misc/foreground/day/0.png", "Day sprite path should be correct"
  assert.equal! fg.sprite_path(is_day: false), "sprites/misc/foreground/night/0.png", "Night sprite path should be correct"
end

def test_foreground_calc_movement(args, assert)
  fg = Foreground.new(x: 0, x_velocity: -5)
  fg.calc
  assert.equal! fg.x, -5, "Foreground should move by x_velocity"
  assert.equal! fg.y, 0, "Foreground y position should remain constant (no gravity effect)"

  # Test with positive velocity
  fg_forward = Foreground.new(x: 0, x_velocity: 5)
  fg_forward.calc
  assert.equal! fg_forward.x, 5, "Foreground should move forward with positive x_velocity"
end
