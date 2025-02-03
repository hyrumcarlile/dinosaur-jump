class Background < BaseObject
  def initialize(w: Grid.w, h: Grid.h, x: 0, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, is_affected_by_gravity: false)
    super
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def can_move?
    false
  end

  def damages_player?
    false
  end

  def sprite_path
    'sprites/misc/background.jpg'
  end
end
