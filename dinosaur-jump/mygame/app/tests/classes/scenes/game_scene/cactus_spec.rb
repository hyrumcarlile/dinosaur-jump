def test_cactus_initialization(args, assert)
  cactus = Cactus.new(x: 500)
  assert.equal! cactus.x, 500, "Cactus x position set correctly"
  assert.true! cactus.damages_player?, "Cactus should damage player"
  assert.true! cactus.can_move?, "Cactus should be able to move"
  assert.true! cactus.sprite_number.between?(0, 6), "Cactus sprite number should be between 0 and 6"
end

def test_cactus_sprite_dimensions(args, assert)
  cactus = Cactus.new
  (0..6).each do |i|
    cactus.sprite_number = i
    dimensions = cactus.sprite_dimensions
    case i
    when 0, 1, 4, 5, 6
      assert.true! dimensions[:w].is_a?(Integer), "Sprite #{i} width should be an integer"
      assert.true! dimensions[:h].is_a?(Integer), "Sprite #{i} height should be an integer"
    when 2, 3
      assert.true! dimensions[:w].is_a?(Integer), "Sprite #{i} width should be an integer"
      assert.true! dimensions[:h].is_a?(Integer), "Sprite #{i} height should be an integer"
    end
  end
end

def test_cactus_sprite_path(args, assert)
  cactus = Cactus.new
  cactus.sprite_number = 0 # Set a specific sprite number for consistent path
  assert.equal! cactus.sprite_path(is_day: true), "sprites/misc/cactus/day/0.png", "Day sprite path should be correct"
  assert.equal! cactus.sprite_path(is_day: false), "sprites/misc/cactus/night/0.png", "Night sprite path should be correct"
end
