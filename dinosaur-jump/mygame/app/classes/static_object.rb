# This class is for objects that move, but are not
# animated, such as the ground and background
class StaticObject < BaseObject
  def initialize(x_velocity: -7, gravity: -1, num_sprites: 1, **args)
    super(x_velocity: x_velocity, gravity: gravity, **args)
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
