def test_game_initializes_with_correct_defaults(args, assert)
  # Direct initialization for testing GameScene (gameplay)
  args.state.scene = GameScene.new(args)
  args.state.scene.tick

  game = args.state.scene

  assert.false! game.player.nil?, "Player state should be initialized"
  assert.equal! game.score, 0, "Initial score should be 0"
  assert.false! game.game_over, "Game should not start in game_over state"
end

def test_player_jumps_when_space_is_pressed(args, assert)
  args.state.scene = GameScene.new(args)
  game = args.state.scene
  player = game.player

  # Ensure player is ready to jump
  player.y_velocity = 0

  args.inputs.keyboard.key_down.space = true

  game.tick

  assert.true! player.y_velocity > 0, "Player should have upward velocity after jump input"
end

def test_collision_with_obstacle_triggers_game_over(args, assert)
  args.state.scene = GameScene.new(args)
  game = args.state.scene
  player = game.player

  # Set lives to 1 so a single collision triggers game over
  player.lives = 1
  # Ensure invincibility check passes (tick_count may be -1 in tests)
  player.player_has_invincibility_until = -100

  # Create an obstacle at player's position
  # We use Cactus as it damages player
  # Player hitbox starts at x + 30, so we offset the obstacle to ensure overlap
  obstacle = Cactus.new(x: player.x + 40)
  args.state.objects = [obstacle]

  game.tick

  assert.true! game.game_over, "Game should end when player hits an obstacle"
end

def test_score_increases_as_game_progresses(args, assert)
  args.state.scene = GameScene.new(args)
  game = args.state.scene
  game.score = 0

  # Create a foreground object that is already off-screen to the left
  # This ensures it gets removed and score increments in the next tick
  # Foreground default width is small enough that -100 should be safe
  object = Foreground.new(x: -500)
  args.state.foreground_objects = [object]

  game.tick

  assert.true! game.score > 0, "Score should increase when foreground object passes"
end
