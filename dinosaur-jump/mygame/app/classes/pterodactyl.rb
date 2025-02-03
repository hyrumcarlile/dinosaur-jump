class Pterodactyl < BaseObject
  def damages_player?
    true
  end

  def can_move?
    true
  end

  def sprite_path
    'sprites/misc/pterodactyl.png'
  end
end
