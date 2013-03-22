class Ballot < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  belongs_to :poll
  
  def cast(p, g, w = 1)
    self.player_id = p.id
    self.game_id = g.id
    self.weight = w
    true
  end
  
end
