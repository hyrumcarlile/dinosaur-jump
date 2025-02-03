class Cactus < BaseObject
  def damages_player?
    true
  end

  def can_move?
    true
  end

  def sprite_path
    'sprites/misc/cactus.png'
  end
end
