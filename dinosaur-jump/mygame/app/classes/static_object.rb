# This class is for objects that move, but are not
# animated, such as the ground and background
class StaticObject < BaseObject
  def initialize(w: 0, h: 0, x: 0, y: 0, x_velocity: -7, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, num_sprites: 1)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity)
    @sprite_number = rand(num_sprites)
  end

  attr_accessor :sprite_number

  def sprite_path(is_day:)
    if is_day
      postfix = 'day'
    else
      postfix = 'night'
    end

    path = "sprites/misc/#{self.class.name.downcase}/#{postfix}/#{@sprite_number}.png"
    # log path
    path
  end
end
