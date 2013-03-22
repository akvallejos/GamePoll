require 'spec_helper'

describe Ballot do
  fixtures :games, :players
  
  it "should have a game" do
    b = Ballot.new
    b.cast(players(:nod), games(:diplomacy))
    b.game.should be_kind_of(Game)
  end
  
  it "should have a player" do
    b = Ballot.new
    b.cast(players(:nod), games(:diplomacy))
    b.player.should be_kind_of(Player)
  end
  
  
  it "should have a weight = 1/number of votes cast" do
    players(:nod).should_receive(:random_weight).and_return(0)
    ballots = players(:nod).votes([games(:risk), games(:decent)])
    ballots.first.weight.should eq(0.5)
  end
  
end

describe Ballot, :broken => true do

end
