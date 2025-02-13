class Cactus < StaticObject
  SPRITE_WIDTH = 10
  SPRITE_HEIGHT = 19

  def initialize(w: 0, h: 0, x: Grid.w, y: 0, x_velocity: DEFAULT_RUNNING_SPEED, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: 0, num_sprites: 7)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity, num_sprites: num_sprites)
    @y = y + GROUND_LEVEL
    @w = sprite_dimensions[:w] * ZOOM_COEFFICIENT
    @h = sprite_dimensions[:h] * ZOOM_COEFFICIENT

    if rand(100) > 60

    end
  end

  def sprite_dimensions
    case @sprite_number
    when 0
      { w: 12, h: 20 }
    when 1
      { w: 12, h: 20 }
    when 2
      { w: 11, h: 14 }
    when 3
      { w: 11, h: 14 }
    when 4
      { w: 14, h: 20 }
    when 5
      { w: 14, h: 20 }
    when 6
      { w: 14, h: 20 }
    end
  end

  def can_move?
    true
  end

  def damages_player?
    true
  end
end
