require 'spec_helper'

describe Player do
  fixtures :players, :games
  
  it "should not be a valid player" do
    Player.new.should_not be_valid
  end
  
  it "should be a valid player" do
    players(:nod).should be_valid
  end
  
  it "should create a ballot for each vote" do
    ballots = players(:nod).votes([games(:risk), games(:decent)])
    ballots.should have(2).items
  end
  
  it "should return a ballot" do
    players(:nod).votes([games(:risk)]).first.should be_kind_of(Ballot)
  end
  
  it "should create a ranked order ballots" do
    ballots = players(:nod).ranked_votes([games(:risk), games(:diplomacy)])
    ballots.first.weight.should eq(2.75)
    ballots.last.weight.should eq(2.5)
  end
  
  it "should assign 1 weight to ballots 4 and more" do
    ballots = players(:nod).ranked_votes(Game.find(:all))
    ballots.last.weight.should eq(1)
  end
end
