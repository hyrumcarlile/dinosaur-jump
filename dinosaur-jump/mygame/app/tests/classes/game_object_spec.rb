def test_game_object_initialization(args, assert)
  game = GameObject.new(args)
  assert.equal! game.game_over, false, "Game should not be over on initialization"
  assert.equal! game.game_duration, 0, "Game duration should be 0 on initialization"
  assert.equal! game.score, 0, "Score should be 0 on initialization"
  assert.true! game.player.is_a?(Player), "Player object should be initialized"
  assert.equal! game.args, args, "Args should be stored"
  assert.true! game.is_day, "Game should start in day mode"
  assert.equal! game.running_speed, DEFAULT_RUNNING_SPEED, "Running speed should be default"
  assert.true! game.next_enemy_spawn.is_a?(Integer), "Next enemy spawn should be set"
  assert.equal! game.args.state.objects.length, 0, "No objects should be present initially"
  assert.equal! game.args.state.sky_objects.length, 0, "No sky objects should be present initially"
  assert.equal! game.args.state.background_objects.length, 0, "No background objects should be present initially"
  assert.equal! game.args.state.foreground_objects.length, 0, "No foreground objects should be present initially"
end

def test_game_object_reset(args, assert)
  game = GameObject.new(args)
  game.game_over = true
  game.game_duration = 100
  game.score = 500
  game.is_day = false
  game.args.state.objects << Cactus.new
  game.args.state.sky_objects << SkyObject.new

  game.send(:handle_reset)

  assert.equal! game.score, 0, "Score should be 0 after reset"
  assert.true! game.is_day, "Game should be day after reset"
  assert.equal! game.args.state.objects.length, 0, "Objects should be cleared after reset"
  assert.equal! game.args.state.sky_objects.length, 0, "Sky objects should be cleared after reset"
  assert.equal! game.args.state.background_objects.length, 0, "Background objects should be cleared after reset"
  assert.equal! game.args.state.foreground_objects.length, 0, "Foreground objects should be cleared after reset"
  assert.equal! game.running_speed, DEFAULT_RUNNING_SPEED, "Running speed should be reset to default"
  assert.true! game.next_enemy_spawn.is_a?(Integer), "Next enemy spawn should be reset"
  assert.nil! game.game_over_at, "game_over_at should be nil after reset"
end

def test_game_object_add_new_objects(args, assert)
  game = GameObject.new(args)
  game.args.state.sky_objects = []
  game.args.state.background_objects = []
  game.args.state.foreground_objects = []

  game.send(:create_new_environment)

  assert.true! game.args.state.sky_objects.length > 0, "Sky objects should be added"
  assert.true! game.args.state.background_objects.length > 0, "Background objects should be added"
  assert.true! game.args.state.foreground_objects.length > 0, "Foreground objects should be added"

  initial_sky_x = game.args.state.sky_objects.first.x
  initial_bg_x = game.args.state.background_objects.first.x
  initial_fg_x = game.args.state.foreground_objects.first.x

  # Simulate movement
  game.args.state.sky_objects.each { |obj| obj.x -= 100 }
  game.args.state.background_objects.each { |obj| obj.x -= 100 }
  game.args.state.foreground_objects.each { |obj| obj.x -= 100 }

  game.send(:create_new_environment) # Should add new objects when existing ones are off-screen

  assert.true! game.args.state.sky_objects.length > 1, "More sky objects should be added"
  assert.true! game.args.state.background_objects.length > 1, "More background objects should be added"
  assert.true! game.args.state.foreground_objects.length > 1, "More foreground objects should be added"

  assert.true! game.args.state.sky_objects.any? { |obj| obj.x > initial_sky_x }, "New sky objects should be further right"
  assert.true! game.args.state.background_objects.any? { |obj| obj.x > initial_bg_x }, "New background objects should be further right"
  assert.true! game.args.state.foreground_objects.any? { |obj| obj.x > initial_fg_x }, "New foreground objects should be further right"
end
