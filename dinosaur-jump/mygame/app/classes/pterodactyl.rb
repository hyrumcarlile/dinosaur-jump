class Pterodactyl < AnimatedObject
  def initialize(w: 0, h: 0, x: 0, y: 0, x_velocity: -9, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, sprite_change_frequency: 5, current_sprite_index: 0, max_sprite_index: 4, action: :flying)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity, sprite_change_frequency: sprite_change_frequency, current_sprite_index: current_sprite_index, max_sprite_index: max_sprite_index, action: action)
    @y = [60, 60, 60, 120, 120, 180].sample
  end

  def damages_player?
    true
  end

  def can_move?
    true
  end
end
