def test_pause_menu_initialization(args, assert)
  game_scene = GameScene.new(args)
  scene = PauseMenuScene.new(args, game_scene)

  assert.equal! scene.selected_index, 0, "Pause Menu should start on first option"
end

def test_pause_menu_navigation(args, assert)
  game_scene = GameScene.new(args)
  scene = PauseMenuScene.new(args, game_scene)

  # Down -> Restart (1)
  args.inputs.keyboard.key_down.down = true
  scene.tick
  assert.equal! scene.selected_index, 1, "Down should move to Restart"

  # Down -> Return (2)
  args.inputs.keyboard.key_down.down = true
  scene.tick
  assert.equal! scene.selected_index, 2, "Down should move to Return"

  # Down -> Resume (0) (Wrap)
  args.inputs.keyboard.key_down.down = true
  scene.tick
  assert.equal! scene.selected_index, 0, "Down should wrap to Resume"
end

def test_pause_menu_resume(args, assert)
  game_scene = GameScene.new(args)
  args.state.scene = game_scene # Set current scene mock

  scene = PauseMenuScene.new(args, game_scene)
  # We are in PauseMenuScene effectively
  args.state.scene = scene

  # Selected is 0 (Resume)
  args.inputs.keyboard.key_down.enter = true
  scene.tick

  assert.equal! args.state.scene, game_scene, "Resume should restore the original game scene"
end
