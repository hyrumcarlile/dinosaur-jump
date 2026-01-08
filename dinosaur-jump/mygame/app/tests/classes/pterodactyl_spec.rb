def test_pterodactyl_initialization(args, assert)
  pterodactyl = Pterodactyl.new(x: 500)
  assert.equal! pterodactyl.x, 500, "Pterodactyl x position set correctly"
  assert.true! pterodactyl.damages_player?, "Pterodactyl should damage player"
  assert.true! pterodactyl.can_move?, "Pterodactyl should be able to move"
  assert.equal! pterodactyl.action, :flying, "Pterodactyl should start in flying action"
  assert.true! pterodactyl.y.between?(59, 181), "Pterodactyl y position should be within range"
end

def test_pterodactyl_sprite_dimensions(args, assert)
  pterodactyl = Pterodactyl.new
  assert.true! pterodactyl.w.is_a?(Integer), "Sprite width should be an integer"
  assert.true! pterodactyl.h.is_a?(Integer), "Sprite height should be an integer"
  assert.equal! pterodactyl.w, Pterodactyl::SPRITE_WIDTH * BaseObject::ZOOM_COEFFICIENT, "Sprite width should match constant"
  assert.equal! pterodactyl.h, Pterodactyl::SPRITE_HEIGHT * BaseObject::ZOOM_COEFFICIENT, "Sprite height should match constant"
end

def test_pterodactyl_sprite_path(args, assert)
  pterodactyl = Pterodactyl.new
  pterodactyl.current_sprite_index = 0 # Set a specific sprite number for consistent path
  assert.equal! pterodactyl.sprite_path(is_day: true), "sprites/misc/pterodactyl/day/flying/0.png", "Day sprite path should be correct"
  assert.equal! pterodactyl.sprite_path(is_day: false), "sprites/misc/pterodactyl/night/flying/0.png", "Night sprite path should be correct"
end
