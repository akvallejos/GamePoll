class Assignment
  attr_accessor :game, :players
  
  def initialize(game, players = Array.new)
    @game = game
    @players = players
  end
end