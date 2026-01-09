def test_sky_object_initialization(args, assert)
  # Test default initialization
  sky_obj = SkyObject.new
  assert.equal! sky_obj.y, 0, "SkyObject should initialize at 0"
  assert.equal! sky_obj.x_velocity, 0, "SkyObject x_velocity should be 0"
  assert.equal! sky_obj.gravity, 0, "SkyObject gravity should be 0"
  assert.true! sky_obj.can_move?, "SkyObject should be able to move"
  assert.false! sky_obj.damages_player?, "SkyObject should not damage player"
  assert.true! sky_obj.sprite_number.between?(0, 2), "SkyObject sprite number should be between 0 and 2"

  # Test custom initialization
  custom_sky_obj = SkyObject.new(y: 200, x_velocity: -5, num_sprites: 1)
  assert.equal! custom_sky_obj.y, 200, "Custom y should be set"
  assert.equal! custom_sky_obj.x_velocity, -5, "Custom x_velocity should be set"
  assert.true! custom_sky_obj.sprite_number.between?(0, 0), "Custom num_sprites should limit sprite_number"
end


def test_sky_object_sprite_path(args, assert)
  sky_obj = SkyObject.new
  sky_obj.sprite_number = 0 # Ensure a consistent sprite number for testing
  assert.equal! sky_obj.sprite_path(is_day: true), "sprites/misc/skyobject/day/0.png", "Day sprite path should be correct"
  assert.equal! sky_obj.sprite_path(is_day: false), "sprites/misc/skyobject/night/0.png", "Night sprite path should be correct"
end

def test_sky_object_calc_movement(args, assert)
  sky_obj = SkyObject.new(x: 0, x_velocity: -2)
  sky_obj.calc
  assert.equal! sky_obj.x, -2, "SkyObject should move by x_velocity"
  assert.equal! sky_obj.y, 0, "SkyObject y position should remain constant (no gravity effect)"

  # Test with positive velocity
  sky_obj_forward = SkyObject.new(x: 0, x_velocity: 2)
  sky_obj_forward.calc
  assert.equal! sky_obj_forward.x, 2, "SkyObject should move forward with positive x_velocity"

  # Test with can_move? returning false
  mock_obj = SkyObject.new(x: 0, x_velocity: -2)
  def mock_obj.can_move?
    false
  end
  mock_obj.calc
  assert.equal! mock_obj.x, 0, "SkyObject should not move if can_move? is false"
end
