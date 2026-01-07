# class PlayerSpec
def test_player_initialization(args, assert)
  player = Player.new
  assert.equal! player.lives, 3, "Player should start with 3 lives"
  assert.equal! player.action, :running, "Player should start in running action"
end

def test_player_jump_input(args, assert)
  player = Player.new
  # Ensure player is on the ground
  player.y = GROUND_LEVEL

  assert.equal! player.lives, 3, "Player should start with 3 lives"
  assert.equal! player.action, :running, "Player should start running"

  # Test inheritance of argument validation
  begin
    Player.new(super_invalid_arg: 1)
    assert.fail! "Player should raise error for unknown args"
  rescue ArgumentError
    assert.ok!
  end

  # Mock the input
  args.inputs.keyboard.key_down.space = true

  player.handle_input(args: args)

  assert.equal! player.action, :jumping, "Player should be jumping after space press"
  assert.equal! player.y_velocity, Player::JUMP_POWER, "Player should have upward velocity"
end

def test_player_hitbox(args, assert)
  player = Player.new(x: 0, y: 0)
  # Hitbox logic: { left: @x + 30, right: @x + @w - 20, bottom: @y, top: @y + @h - 20 }
  hb = player.hitbox
  assert.equal! hb[:left], 30, "Hitbox left should be offset by 30"
  assert.equal! hb[:right], player.x + player.w - 20, "Hitbox right should be correct"
  assert.equal! hb[:bottom], player.y, "Hitbox bottom should be player y"
  assert.equal! hb[:top], player.y + player.h - 20, "Hitbox top should be correct"
end
