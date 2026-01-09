def test_menu_initialization(args, assert)
  scene = MenuScene.new(args)
  assert.equal! scene.selected_index, 0, "Menu should initialize with start option selected"
end

def test_menu_navigation_wrap(args, assert)
  scene = MenuScene.new(args)

  # Up from 0 should wrap to last option (1)
  args.inputs.keyboard.key_down.up = true
  scene.tick
  assert.equal! scene.selected_index, 1, "Up from first option should wrap to last"

  # Down from last option (1) should wrap to first (0)
  args.inputs.keyboard.key_down.up = false
  args.inputs.keyboard.key_down.down = true
  scene.tick
  assert.equal! scene.selected_index, 0, "Down from last option should wrap to first"
end

def test_menu_navigation_linear(args, assert)
  scene = MenuScene.new(args)

  # Down from 0 should go to 1
  args.inputs.keyboard.key_down.down = true
  scene.tick
  assert.equal! scene.selected_index, 1, "Down should increment selection"

  # Up from 1 should go to 0
  args.inputs.keyboard.key_down.down = false
  args.inputs.keyboard.key_down.up = true
  scene.tick
  assert.equal! scene.selected_index, 0, "Up should decrement selection"
end
