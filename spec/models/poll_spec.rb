require 'spec_helper'

describe Poll do
  fixtures :players, :games
  
  before :each do 
    @current_poll = Poll.new
    players(:nod).should_receive(:random_weight).and_return(0)
    @current_poll.ballots << players(:nod).votes([games(:diplomacy)])  
    players(:bonz).should_receive(:random_weight).once.and_return(1)
    @current_poll.ballots << players(:bonz).votes([games(:diplomacy), games(:risk)])  
    players(:prez).should_receive(:random_weight).and_return(0)
    @current_poll.ballots << players(:prez).votes([games(:decent), games(:n_hex)])
    @current_poll.save
  end
  
  it " should return game with most votes" do
    @current_poll.winner.should eq(games(:diplomacy).name)
  end
  
  it "should weight :diplomacy with 2.0 votes" do
    @current_poll.votes_for(games(:diplomacy)).should eq(2.0)
  end
  
  it "should rank games by place" do
    @current_poll.rankings.should have(4).items
    @current_poll.rankings[2].name.should eq(games(:risk).name)
  end
  
  it "should return 3 players" do
    @current_poll.players.uniq.should have(3).items
  end
  
  it "should assign all players to one game" do
    @current_poll.assignments.should have(1).items
  end
  
  it "should assign all players to diplomacy" do
    @current_poll.assignments.first.game.should eq(games(:diplomacy))
  end
  
  it "should have three players assigned to diplomacy" do
    @current_poll.assignments.first.players.should have(3).items
  end
end

describe Poll do
  fixtures :players, :games
  
  before :each do 
    @current_poll = Poll.new
    players(:zel).should_receive(:random_weight).and_return(3)
    @current_poll.ballots << players(:zel).votes([games(:n_hex)])
    players(:pugly).should_receive(:random_weight).and_return(2)
    @current_poll.ballots << players(:pugly).votes([games(:risk)])
    players(:nod).should_receive(:random_weight).and_return(0)
    @current_poll.ballots << players(:nod).votes([games(:diplomacy)])  
    players(:bonz).should_receive(:random_weight).once.and_return(0)
    @current_poll.ballots << players(:bonz).votes([games(:diplomacy), games(:risk)])  
    players(:prez).should_receive(:random_weight).and_return(0)
    @current_poll.ballots << players(:prez).votes([games(:decent), games(:n_hex)])
    @current_poll.save
  end
  
  it "should assign players to 2 games" do
    @current_poll.assignments.should have(2).items
  end
  
  it "should have n_hex as the winner" do
    @current_poll.assignments.first.game.should eq(games(:n_hex))
  end
  
  it "should assign diplomacy second since risk's min players is 3 and there are only 2 players left" do
    @current_poll.assignments[1].game.should eq(games(:diplomacy))
  end
  
  it "should assign 3 players to n_hex + unassigned to n_hex" do
    @current_poll.assignments.first.players.should have(3).items
  end
  
  it "should assign 2 players to diplomacy" do
    @current_poll.assignments[1].players.should have(2).items
  end
end

# Ranked Order Polling
describe Poll do
  fixtures :players, :games
  
  before :each do 
    @ranked_poll = Poll.new
    @ranked_poll.voting = 'ranked'
    @ranked_poll.ballots << players(:zel).ranked_votes([games(:n_hex)])
    @ranked_poll.ballots << players(:pugly).ranked_votes([games(:risk)])
    @ranked_poll.ballots << players(:nod).ranked_votes([games(:diplomacy)])  
    @ranked_poll.ballots << players(:bonz).ranked_votes([games(:diplomacy), games(:risk)])  
    @ranked_poll.ballots << players(:prez).ranked_votes([games(:decent), games(:n_hex)])
    @ranked_poll.save
  end
  
  it "should return ranked poll" do
    @ranked_poll.voting.should eq("ranked")
  end
  
  it "should assign diplomacy a weight of 5" do
    @ranked_poll.votes_for(games(:diplomacy)).should eq(5.5)
  end
  
  it "should assign n_hex a weight of 5.25" do
    @ranked_poll.votes_for(games(:n_hex)).should eq(5.25)
  end
  
end
