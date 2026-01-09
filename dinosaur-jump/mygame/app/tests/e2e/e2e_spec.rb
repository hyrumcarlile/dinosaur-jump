def test_game_launch_shows_menu(args, assert)
  # Simulate fresh game start
  args.state.scene = nil
  main(args)

  assert.true! args.state.scene.is_a?(MenuScene), "Game should launch into MenuScene"
end

def test_menu_navigation(args, assert)
  args.state.scene = MenuScene.new(args)

  # Default is Start Game (index 0)
  assert.equal! args.state.scene.selected_index, 0, "Default selection should be 0"

  # Press Down -> Exit (index 1)
  args.inputs.keyboard.key_down.down = true
  args.state.scene.tick
  assert.equal! args.state.scene.selected_index, 1, "Down key should move selection to 1"

  # Press Up -> Start Game (index 0)
  args.inputs.keyboard.key_down.down = false
  args.inputs.keyboard.key_down.up = true
  args.state.scene.tick
  assert.equal! args.state.scene.selected_index, 0, "Up key should move selection back to 0"
end

def test_menu_starts_game(args, assert)
  args.state.scene = MenuScene.new(args)

  # Select Start Game
  args.state.scene.selected_index = 0
  args.inputs.keyboard.key_down.enter = true

  args.state.scene.tick

  assert.true! args.state.scene.is_a?(GameScene), "Enter on 'Start Game' should switch to GameScene"
end

def test_gameplay_jump_controls(args, assert)
  # Start in gameplay
  args.state.scene = GameScene.new(args)
  game = args.state.scene

  # Ensure clean state
  game.player.y_velocity = 0

  # Press Space to Jump
  args.inputs.keyboard.key_down.space = true
  game.tick

  assert.true! game.player.y_velocity > 0, "Space key should trigger jump velocity"
  assert.equal! game.player.action, :jumping, "Player action should be :jumping"
end

def test_gameplay_crouch_controls(args, assert)
  # Start in gameplay
  args.state.scene = GameScene.new(args)
  game = args.state.scene

  # Press C to Crouch
  args.inputs.keyboard.key_down.c = true
  game.tick

  assert.equal! game.player.action, :crouching, "C key should trigger crouching action"
end

def test_collision_cause_life_loss(args, assert)
  # Start in gameplay
  args.state.scene = GameScene.new(args)
  game = args.state.scene

  initial_lives = game.player.lives
  game.player.player_has_invincibility_until = -100 # Ensure vulnerable

  # Spawn obstacle at player position
  # Offset by 40 to hit the hitbox (x+30)
  obstacle = Cactus.new(x: game.player.x + 40)
  game.args.state.objects = [obstacle]

  game.tick

  assert.equal! game.player.lives, initial_lives - 1, "Collision should reduce lives by 1"
end

def test_e2e_pause_menu_flow(args, assert)
  # Start Game
  args.state.scene = GameScene.new(args)
  game_scene = args.state.scene

  # Press Escape
  args.inputs.keyboard.key_down.escape = true
  # Tick GameScene to process input
  game_scene.tick

  assert.true! args.state.scene.is_a?(PauseMenuScene), "Escape should switch to PauseMenuScene"
  pause_scene = args.state.scene

  # Resume (Index 0)
  args.inputs.keyboard.key_down.escape = false
  args.inputs.keyboard.key_down.enter = true
  pause_scene.tick

  assert.equal! args.state.scene, game_scene, "Resume should return to original game scene object"

  # Pause Again
  args.inputs.keyboard.key_down.enter = false
  args.inputs.keyboard.key_down.escape = true
  args.state.scene.tick
  pause_scene = args.state.scene

  # Navigate to Restart (Index 1)
  args.inputs.keyboard.key_down.escape = false
  args.inputs.keyboard.key_down.down = true
  pause_scene.tick # Selected Index 1
  assert.equal! pause_scene.selected_index, 1

  # Select Restart
  args.inputs.keyboard.key_down.down = false
  args.inputs.keyboard.key_down.enter = true
  pause_scene.tick

  assert.true! args.state.scene.is_a?(GameScene), "Restart should switch to GameScene"
  assert.false! args.state.scene == game_scene, "Restart should create a NEW GameScene instance"

  # Pause Again
  args.inputs.keyboard.key_down.enter = false
  args.inputs.keyboard.key_down.escape = true
  args.state.scene.tick
  pause_scene = args.state.scene

  # Navigate to Return to Menu (Index 2)
  args.inputs.keyboard.key_down.escape = false
  args.inputs.keyboard.key_down.down = true
  pause_scene.tick # 1 (Restart)
  pause_scene.tick # 2 (Return)
  assert.equal! pause_scene.selected_index, 2 # Assuming wrap/start 0

  # Select Return
  args.inputs.keyboard.key_down.down = false
  args.inputs.keyboard.key_down.enter = true
  pause_scene.tick

  assert.true! args.state.scene.is_a?(MenuScene), "Return to Menu should switch to MenuScene"
end
