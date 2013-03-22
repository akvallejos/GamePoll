module BallotsHelper
  
  def players_available
    Player.all.collect { |p| p.name }
  end
end
