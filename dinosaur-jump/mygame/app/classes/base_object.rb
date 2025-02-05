class BaseObject
  def initialize(w: 0, h: 0, x: 0, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, sprite_change_frequency: 5)
    @w = w
    @h = h
    @x = x
    @y = y
    @x_velocity = x_velocity
    @y_velocity = y_velocity
    @x_acceleration = x_acceleration
    @y_acceleration = y_acceleration
    @gravity = gravity
    @sprite_change_frequency = sprite_change_frequency
    @current_sprite_index = 0
  end

  attr_accessor :w, :h, :x, :y, :x_velocity, :y_velocity, :x_acceleration, :y_acceleration, :gravity, :sprite_change_frequency, :current_sprite_index

  # This function should be implemented in every instantiable class
  # and calculates where the object should be drawn depending on
  # that objects position, velocity, and acceleration and any changes
  # in those values based on input or game events

  # objects can override this if they do class specific things, but should
  # finish by calling super to calculate position, velocity, and acceleration
  def calc
    return unless can_move?

    # calculate positions from position and velocity
    @x += @x_velocity
    @y = [@y + @y_velocity, 0].max

    # calculate velocity from velocity and acceleration
    @x_velocity += @x_acceleration
    if @y.positive?
      @y_velocity += @gravity
    else
      @y_velocity = 0
    end
  end

  def damages_player?
    raise NotImplementedError
  end

  def sprite_path
    raise NotImplementedError
  end

  def can_move?
    raise NotImplementedError
  end

  def sprites
    raise NotImplementedError
  end

  def to_sprite
    # change to the next sprite after the specified number of ticks
    if (Kernel.tick_count % @sprite_change_frequency).zero?
      @current_sprite_index += 1
      @current_sprite_index = 0 if @current_sprite_index >= sprites.length
    end

    {
      x: @x,
      y: @y,
      w: @w,
      h: @h,
      path: sprites[@current_sprite_index]
    }
  end
end
