require 'spec_helper'

describe Game do
  
  before :each do 
    @valid_game = Game.new(:name => 'test name', :min_players => 2, :max_players => 4)
  end
  
  it "should require name" do
    @valid_game.should be_valid
  end
  
  it "should require min players" do
    @valid_game.should be_valid
  end
  
  it "should require max players" do
    @valid_game.should be_valid
  end
  
  it "should return true if number_of_players? is between min and max players" do
    @valid_game.number_of_players?(3).should be_true
  end
  
  it "should return true if the number_of_players? is equal to min players" do
    @valid_game.number_of_players?(2).should be_true
  end
  
  it "should return true if number_of_players? is between min and max players" do
    @valid_game.number_of_players?(4).should be_true
  end
  
  it "should return false if the number_of_players? is greater than max players" do
    @valid_game.number_of_players?(5).should be_false
  end

  it "should return false if the number_of_players? is less than min players" do
    @valid_game.number_of_players?(1).should be_false
  end  
end