class Player < BaseObject
  ALLOWED_JUMP_INCREASE_TIME = 10
  JUMP_INCREASE_POWER = 1
  JUMP_POWER = 15

  def initialize(w: 60, h: 60, x: 30, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, is_affected_by_gravity: true, sprite_change_frequency: 5, action_at: nil)
    super
    @w = w
    @h = h
    @x = x
    @y = y
    @action_at = action_at
  end

  attr_accessor :action, :action_at, :allowed_jump_increase_time

  def handle_input(args:)
    if args.inputs.keyboard.key_down.space
      if @y == 0 # player is on the ground and can jump
        @y_velocity = JUMP_POWER

        # record when the action took place so that we can
        # add jump power for the first 10 frames if space
        # is held down
        @action_at = Kernel.tick_count
      end
    end

    # if the space bar is being held
    if args.inputs.keyboard.key_held.space
      # if the player is jumping
      # and the elapsed time is less than
      # the allowed time
      if @y > 0 && (@action_at.elapsed_time < ALLOWED_JUMP_INCREASE_TIME)
         # increase the y_velocity by the increase power
         @y_velocity += JUMP_INCREASE_POWER
      end
    end
    puts @y_velocity
  end

  def damages_player?
    false
  end

  def can_move?
    true
  end

  def hitbox
    { left: @x + 30, right: @x + @w - 20, bottom: @y, top: @y + @h - 20 }
  end

  def check_for_collisions(objects:)
    objects.each do |object|
      mins_overlap = (object.x >= hitbox[:left] && object.x <= hitbox[:right]) && (object.y >= hitbox[:bottom] && object.y <= hitbox[:top])
      maxs_overlap = (object.x + object.w >= hitbox[:left] && object.x + object.w <= hitbox[:right]) && (object.y + object.h >= hitbox[:bottom] && object.y + object.h <= hitbox[:top])

      next unless mins_overlap || maxs_overlap # no collision so check the next object

      return true # collision
    end

    false # no collisions with any objects
  end

  def sprites
    [
      'sprites/misc/dinosaur/dinosaur-1.png',
      'sprites/misc/dinosaur/dinosaur-2.png',
      'sprites/misc/dinosaur/dinosaur-3.png',
      'sprites/misc/dinosaur/dinosaur-4.png',
      'sprites/misc/dinosaur/dinosaur-5.png'
    ]
  end
end
