class Player < ActiveRecord::Base
  attr_accessible :name, :id
  has_many :ballots
  has_many :games, :through => :ballots
  
  validates :name, :presence => true
  
  
  def votes(picks)
    new_ballots = []
    weight = (1.0 + random_weight) / picks.length
    picks.each do |p|
      b = Ballot.new
      b.cast(self, p, weight)
      new_ballots << b
    end
    ballots << new_ballots
    new_ballots
  end
  
  def ranked_votes(picks)
    new_ballots = []
    weight = [2.75, 2.5, 2, 1]
    picks.each_with_index do |p, index|
      b = Ballot.new
      weight[index] ||= 1 #ensure minimum 1
      b.cast(self, p, weight[index])
      new_ballots << b
    end #picks.each_with_index
    new_ballots
  end
  
  private 
  
  def random_weight
    rand(4)
  end
end
