class Game < ActiveRecord::Base
  attr_accessible :max_players, :min_players, :name, :homebrew
  has_many :ballots
  
  validates :name, :presence => true
  validates :max_players, :presence => true, :numericality => true
  validates :min_players, :presence => true, :numericality => true
  
  def number_of_players?(number)
    min_players <= number and number <= max_players
  end
     
end
