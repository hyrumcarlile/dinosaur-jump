class Pterodactyl < BaseObject
  def damages_player?
    true
  end

  def can_move?
    true
  end

  def sprites
    [
      'sprites/misc/dragon-reversed/dragon-0.png',
      'sprites/misc/dragon-reversed/dragon-1.png',
      'sprites/misc/dragon-reversed/dragon-2.png',
      'sprites/misc/dragon-reversed/dragon-3.png',
      'sprites/misc/dragon-reversed/dragon-4.png',
      'sprites/misc/dragon-reversed/dragon-5.png'
    ]
  end
end
