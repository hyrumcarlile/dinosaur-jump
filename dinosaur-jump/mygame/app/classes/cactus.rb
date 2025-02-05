class Cactus < BaseObject
  def damages_player?
    true
  end

  def can_move?
    true
  end

  def sprites
    ['sprites/misc/cactus.png']
  end
end
