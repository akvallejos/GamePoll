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

describe Player, :profiles => :true do
  fixtures :players, :games
  
  before :each do
    p1 = Poll.new(:voting => 'ranked')
    p1.ballots << players(:nod).ranked_votes([games(:diplomacy), games(:risk)])
    p1.ballots << players(:bonz).ranked_votes([games(:risk), games(:decent)])
    p1.save
    
    p2 = Poll.new(:voting => 'ranked')
    p2.ballots << players(:nod).ranked_votes([games(:risk), games(:decent)])
    p2.ballots << players(:bonz).ranked_votes([games(:diplomacy), games(:clue)])
    p2.save
  end #each
  
  it "should return game most voted for" do
    players(:nod).most_voted_for_game.should eq(games(:risk).name)
  end
  
  it "it should return the games voted for by count" do
    players(:nod).voting_history("ranked").should eq({'Risk' => 2, 'Diplomacy' => 1, 'Decent' => 1})
  end
  
  it "should return the games and their total voted weight" do
    players(:nod).ranked_voting_totals.should eq({'Risk' => 5.25, 'Diplomacy' => 2.75, 'Decent' => 2.5})
  end
end #Game :profile