# This class is for objects that move and are animated,
# such as player and pterodactyl
class AnimatedObject < BaseObject
  def initialize(sprite_change_frequency: 5, max_sprite_index: 4, action: nil, **args)
    super(**args)
    @sprite_change_frequency = sprite_change_frequency
    @max_sprite_index = max_sprite_index
    @current_sprite_index = 0
    @action = action
  end

  attr_accessor :sprite_change_frequency, :max_sprite_index, :current_sprite_index, :action

  def rotate_sprite(tick_count: Kernel.tick_count)
    if tick_count % @sprite_change_frequency == 0
      @current_sprite_index += 1
      @current_sprite_index = 0 if @current_sprite_index >= @max_sprite_index
    end
  end

  def sprite_path(is_day:)
    if is_day
      postfix = 'day'
    else
      postfix = 'night'
    end
    # change to the next sprite after the specified number of ticks
    log "current_sprite_index: #{@current_sprite_index}"
    log "max_sprite_index: #{@max_sprite_index}"

    path = "sprites/misc/#{self.class.name.downcase}/#{postfix}/#{@action.to_s}/#{@current_sprite_index}.png"
    # log path
    path
  end
end
