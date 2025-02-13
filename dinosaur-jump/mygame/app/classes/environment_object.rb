class EnvironmentObject < StaticObject
  def initialize(w: 0, h: 0, x: 0, y: 0, x_velocity: DEFAULT_RUNNING_SPEED, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: 0, num_sprites: 1)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity, num_sprites: num_sprites)
  end

  # Calculate where the object should be drawn depending on
  # that objects position, velocity, and acceleration and any changes
  # in those values based on input or game events
  def calc
    return unless can_move?

    @x += @x_velocity
  end

  def damages_player?
    false
  end

  def can_move?
    true
  end
end
