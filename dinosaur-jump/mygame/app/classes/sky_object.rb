class SkyObject < EnvironmentObject
  def initialize(w: 0, h: 0, x: 0, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: 0, num_sprites: 1)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity)
  end

  SPRITE_WIDTH = 96 * 2
  SPRITE_HEIGHT = 112 * 2
end
