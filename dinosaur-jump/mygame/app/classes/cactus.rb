class Cactus < StaticObject
  SPRITE_WIDTH = 10
  SPRITE_HEIGHT = 19

  def initialize(x: Grid.w, x_velocity: DEFAULT_RUNNING_SPEED, num_sprites: 7, **args)
    super(x: x, x_velocity: x_velocity, num_sprites: num_sprites, **args)
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
