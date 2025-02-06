# This class is for objects that move and are animated,
# such as player and pterodactyl
class AnimatedObject < BaseObject
  def initialize(w: 0, h: 0, x: 0, y: 0, x_velocity: 0, y_velocity: 0, x_acceleration: 0, y_acceleration: 0, gravity: -1, current_sprite_index: 0, sprite_change_frequency: 5, max_sprite_index: 4, action: nil)
    super(w: w, h: h, x: x, y: y, x_velocity: x_velocity, y_velocity: y_velocity, x_acceleration: x_acceleration, y_acceleration: y_acceleration, gravity: gravity)
    @sprite_change_frequency = sprite_change_frequency
    @max_sprite_index = max_sprite_index
    @current_sprite_index = 0
    @action = action
  end

  attr_accessor :sprite_change_frequency, :max_sprite_index, :current_sprite_index, :action

  def sprite_path(is_day:)
    postfix = is_day ? 'day' : 'night'
    # change to the next sprite after the specified number of ticks
    puts "current_sprite_index: #{@current_sprite_index}"
    puts "max_sprite_index: #{@max_sprite_index}"
    if Kernel.tick_count % @sprite_change_frequency == 0
      @current_sprite_index += 1
      @current_sprite_index = 0 if @current_sprite_index >= @max_sprite_index
    end

    "sprites/misc/#{self.class.name.downcase}/#{postfix}/#{@action.to_s}/#{@current_sprite_index}.png"
  end
end
