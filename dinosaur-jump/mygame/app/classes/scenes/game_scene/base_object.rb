class BaseObject
  SPRITE_WIDTH = 0
  SPRITE_HEIGHT = 0

  def initialize(w: nil, h: nil, x: 0, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, **args)
    @w = w || default_width
    @h = h || default_height
    @x = x
    @y = y
    @x_velocity = x_velocity
    @y_velocity = y_velocity
    @x_acceleration = x_acceleration
    @y_acceleration = y_acceleration
    @gravity = gravity
    @is_day = true

    raise ArgumentError, "Unknown arguments passed to initializer for #{self.class.name}: #{args.keys.join(', ')}" unless args.empty?
  end

  attr_accessor :w, :h, :x, :y, :x_velocity, :y_velocity, :x_acceleration, :y_acceleration, :gravity, :is_day

  # Calculate where the object should be drawn depending on
  # that objects position, velocity, and acceleration and any changes
  # in those values based on input or game events
  def calc
    return unless can_move?

    # calculate positions from position and velocity
    @x += @x_velocity
    @y = [@y + @y_velocity, GROUND_LEVEL].max

    # calculate velocity from velocity and acceleration
    @x_velocity += @x_acceleration
    if @y > GROUND_LEVEL
      @y_velocity += @gravity
    else
      @y_velocity = 0
    end
  end

  def damages_player?
    raise NotImplementedError("\#damages_player? not implemented for #{self}")
  end

  def default_width
    self.class::SPRITE_WIDTH * ZOOM_COEFFICIENT
  end

  def default_height
    self.class::SPRITE_HEIGHT * ZOOM_COEFFICIENT
  end

  def sprite_path(is_day:)
    raise NotImplementedError("\#sprite_path? not implemented for #{self.class.name}")
  end

  def can_move?
    raise NotImplementedError("\#can_move? not implemented for #{self.class.name}")
  end

  def to_sprite(is_day:)
    {
      x: @x,
      y: @y,
      w: @w,
      h: @h,
      path: sprite_path(is_day: is_day)
    }
  end

  private
  def log(message)
    return unless LOGGER

    puts message
  end
end
