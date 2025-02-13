class Player < AnimatedObject
  SPRITE_WIDTH = 22
  SPRITE_HEIGHT = 21
  INVINCIBILITY_LENGTH = 120

  def initialize(w: 0, h: 0, x: 30, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, sprite_change_frequency: 5, current_sprite_index: 0, max_sprite_index: 4, action: :running, action_at: nil)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity, sprite_change_frequency: sprite_change_frequency, current_sprite_index: current_sprite_index, max_sprite_index: max_sprite_index, action: action)
    @y = y + GROUND_LEVEL
    @action_at = action_at
    @lives = 3
    @player_has_invincibility_until = 0
    @max_lives = 3
  end

  ALLOWED_JUMP_INCREASE_TIME = 10
  JUMP_INCREASE_POWER = 1
  JUMP_POWER = 15
  MAX_SPRITE_INDEXES_FOR_ACTIONS = {
    running: 3,
    jumping: 0,
    crouching: 3
  }

  attr_accessor :action, :action_at, :lives, :temporary_invincibility_from, :hurt_at, :player_has_invincibility_until, :lives, :max_lives

  def handle_input(args:)
    if args.inputs.keyboard.key_down.space
      if @y == GROUND_LEVEL # player is on the ground and can jump
        @y_velocity = JUMP_POWER
        handle_action_change(new_action: :jumping)
      end

    # if the space bar is being held
    elsif args.inputs.keyboard.key_held.space
      # if the player is jumping
      # and the elapsed time is less than
      # the allowed time
      if @y > GROUND_LEVEL && @action == :jumping && (@action_at.elapsed_time < ALLOWED_JUMP_INCREASE_TIME)
         # increase the y_velocity by the increase power
         @y_velocity += JUMP_INCREASE_POWER
      end

    elsif args.inputs.keyboard.key_held.c || args.inputs.keyboard.key_down.c
      handle_action_change(new_action: :crouching)

    # player is on the ground and no keys are being pressed
    # so make the action the default :running
    elsif @y == GROUND_LEVEL
      handle_action_change(new_action: :running)
    end
  end

  def damages_player?
    false
  end

  def can_move?
    true
  end

  def sprite_dimensions
    case @action
    when :running
      { w: 22, h: 21 }
    when :crouching
      { w: 30, h: 17 }
    when :jumping
      { w: 22, h: 23 }
    end
  end

  def hitbox
    { left: @x + 30, right: @x + @w - 20, bottom: @y, top: @y + @h - 20 }
  end

  def check_for_collisions(objects:)
    return if Kernel.tick_count < @player_has_invincibility_until

    objects.each do |object|
      mins_overlap = (object.x >= hitbox[:left] && object.x <= hitbox[:right]) && (object.y >= hitbox[:bottom] && object.y <= hitbox[:top])
      maxs_overlap = (object.x + object.w >= hitbox[:left] && object.x + object.w <= hitbox[:right]) && (object.y + object.h >= hitbox[:bottom] && object.y + object.h <= hitbox[:top])

      next unless mins_overlap || maxs_overlap # no collision so check the next object

      @hurt_at = Kernel.tick_count
      @player_has_invincibility_until = Kernel.tick_count + INVINCIBILITY_LENGTH
      @lives -= 1
      return true # collision
    end

    false # no collisions with any objects
  end

  def sprite_path(is_day:)
    # if hurt at occured in last 2 seconds and still have lives, flash the player sprite
    if @hurt_at && @lives > 0 && Kernel.tick_count - @hurt_at < INVINCIBILITY_LENGTH
      if (((Kernel.tick_count - @hurt_at).round.to_i / 10).round.to_i % 2).zero?
        return 'sprites/misc/blank.png'
      else
        return super(is_day: is_day)
      end
    else
      return super(is_day: is_day)
    end
  end

  private
  def handle_action_change(new_action:)
    raise RuntimeError "No '#{new_action.to_s}' action defined for class: Player" unless MAX_SPRITE_INDEXES_FOR_ACTIONS.keys.include? new_action

    return if @action == new_action

    # record when the action took place so that we can
    # add jump power for the first 10 frames if space
    # is held down
    @action_at = Kernel.tick_count

    @action = new_action
    @gravity = @action == :crouching ? -2 : -1
    @w = sprite_dimensions[:w] * ZOOM_COEFFICIENT
    @h = sprite_dimensions[:h] * ZOOM_COEFFICIENT
    @current_sprite_index = 0
    @max_sprite_index = MAX_SPRITE_INDEXES_FOR_ACTIONS[@action.to_sym]
  end
end
