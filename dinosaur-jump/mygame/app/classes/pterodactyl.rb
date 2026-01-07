class Pterodactyl < AnimatedObject
  SPRITE_WIDTH = 24
  SPRITE_HEIGHT = 22

  def initialize(x: Grid.w, x_velocity: DEFAULT_RUNNING_SPEED - 4, gravity: 0, action: :flying, **args)
    super(x: x, x_velocity: x_velocity, gravity: gravity, action: action, **args)
    @y = [60, 60, 60, 120, 120, 180].sample + GROUND_LEVEL
  end

  def damages_player?
    true
  end

  def can_move?
    true
  end
end
