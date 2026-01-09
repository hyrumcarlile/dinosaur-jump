class Background < EnvironmentObject
  def initialize(y: GROUND_LEVEL, x_velocity: DEFAULT_RUNNING_SPEED + 5, **args)
    super(y: y, x_velocity: x_velocity, **args)
  end

  SPRITE_WIDTH = 96
  SPRITE_HEIGHT = 27
end
