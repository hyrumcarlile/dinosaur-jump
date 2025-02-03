class BaseObject
  def initialize(w: 0, h: 0, x: 0, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1)
    @w = w
    @h = h
    @x = x
    @y = y
    @x_velocity = x_velocity
    @y_velocity = y_velocity
    @x_acceleration = x_acceleration
    @y_acceleration = y_acceleration
    @gravity = gravity
  end

  attr_accessor :w, :h, :x, :y, :x_velocity, :y_velocity, :x_acceleration, :y_acceleration, :gravity

  def calc
    return unless can_move?
    # This function should be implemented in every instantiable class
    # and calculates where the object should be drawn depending on
    # that objects position, velocity, and acceleration and any changes
    # in those values based on input or game events

    # objects can override this if they do class specific things, but should
    # finish by calling super to calculate position, velocity, and acceleration

    # calculate positions from position and velocity
    @x = @x + @x_velocity
    @y = [@y + @y_velocity, 0].max

    # calculate velocity from velocity and acceleration
    @x_velocity = @x_velocity + @x_acceleration
    if @y > 0
      @y_velocity = @y_velocity + @gravity
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

  def to_sprite
    {
      x: @x,
      y: @y,
      w: @w,
      h: @h,
      path: sprite_path
    }
  end
end
