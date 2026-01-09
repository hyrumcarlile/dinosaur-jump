class Foreground < EnvironmentObject
  def initialize(num_sprites: 5, **args)
    super(num_sprites: num_sprites, **args)
  end

  SPRITE_WIDTH = 16
  SPRITE_HEIGHT = 15
end
