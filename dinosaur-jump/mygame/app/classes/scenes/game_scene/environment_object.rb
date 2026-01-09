class EnvironmentObject < StaticObject
  def initialize(gravity: 0, **args)
    super(gravity: gravity, **args)
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
