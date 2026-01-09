class SkyObject < EnvironmentObject
  def initialize(x_velocity: 0, **args)
    super(x_velocity: x_velocity, **args)
  end

  SPRITE_WIDTH = 96 * 2
  SPRITE_HEIGHT = 112 * 2
end
