class Cactus < StaticObject
  SPRITE_WIDTH = 10
  SPRITE_HEIGHT = 19

  def initialize(w: 0, h: 0, x: Grid.w, y: 0, x_velocity: RUNNING_SPEED, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: 0, num_sprites: 1)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity)
    @y = y + GROUND_LEVEL
  end

  def can_move?
    true
  end

  def damages_player?
    true
  end
end
