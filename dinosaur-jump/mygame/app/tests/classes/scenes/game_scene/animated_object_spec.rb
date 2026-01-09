def test_animated_object_initialization(args, assert)
  obj = AnimatedObject.new(w: 100, h: 100)
  assert.equal! obj.sprite_change_frequency, 5, "Default sprite_change_frequency should be 5"
  assert.equal! obj.max_sprite_index, 4, "Default max_sprite_index should be 4"
  assert.equal! obj.current_sprite_index, 0, "Default current_sprite_index should be 0"
  assert.nil! obj.action, "Default action should be nil"

  obj = AnimatedObject.new(w: 100, h: 100, sprite_change_frequency: 10, max_sprite_index: 2, action: :idle)
  assert.equal! obj.sprite_change_frequency, 10, "Custom sprite_change_frequency should be set"
  assert.equal! obj.max_sprite_index, 2, "Custom max_sprite_index should be set"
  assert.equal! obj.action, :idle, "Custom action should be set"
end

def test_animated_object_rotate_sprite(args, assert)
  obj = AnimatedObject.new(w: 100, h: 100, sprite_change_frequency: 2, max_sprite_index: 2) # Sprites 0, 1
  obj.current_sprite_index = 0

  # Tick 1: No change
  obj.rotate_sprite(tick_count: 1)
  assert.equal! obj.current_sprite_index, 0, "Sprite should not rotate on tick 1"

  # Tick 2: Change to 1
  obj.rotate_sprite(tick_count: 2)
  assert.equal! obj.current_sprite_index, 1, "Sprite should rotate to 1 on tick 2"

  # Tick 3: No change
  obj.rotate_sprite(tick_count: 3)
  assert.equal! obj.current_sprite_index, 1, "Sprite should not rotate on tick 3"
end

def test_animated_object_sprite_path(args, assert)
  # Test with action
  obj_with_action = AnimatedObject.new(w: 100, h: 100, action: :running)
  obj_with_action.current_sprite_index = 1
  assert.equal! obj_with_action.sprite_path(is_day: true), "sprites/misc/animatedobject/day/running/1.png", "Day sprite path with action should be correct"
  assert.equal! obj_with_action.sprite_path(is_day: false), "sprites/misc/animatedobject/night/running/1.png", "Night sprite path with action should be correct"

  # Test without action (action is nil)
  obj_no_action = AnimatedObject.new(w: 100, h: 100)
  obj_no_action.current_sprite_index = 0
  assert.equal! obj_no_action.sprite_path(is_day: true), "sprites/misc/animatedobject/day//0.png", "Day sprite path without action should be correct"
  assert.equal! obj_no_action.sprite_path(is_day: false), "sprites/misc/animatedobject/night//0.png", "Night sprite path without action should be correct"
end
