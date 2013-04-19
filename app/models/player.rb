class Player < ActiveRecord::Base
  attr_accessible :name, :id
  has_many :ballots
  has_many :games, :through => :ballots
  has_many :polls, :through => :ballots, :uniq => true
  
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
  
  def most_voted_for_game
    voting_history.keys.last
  end
  
  def voting_history(type = nil)
    if type.nil?
      return games.count(:group => :name, :order => "count(*)")
    else
      return ballots.where("poll_id IN (?)", polls.where(:voting => type)).
              collect{|ballot| {ballot.game.name => 1 }}.
              inject({}) {|hash, group| hash.merge(group) {|key, total, value| total + value}}
    end
  end #voting_history
  
  def ranked_voting_totals
    ballots.where("poll_id IN (?)", polls.where(:voting => 'ranked')). #fetch all polls
    collect{|ballot| { ballot.game.name => ballot.weight } }. #iterate over polls and sum the weight by game
    inject({}){|hash, group| hash.merge(group) {|key, total, value| total.to_f + value.to_f }} #merge the hashes together and sum
    
  end
  
  private 
  
  def random_weight
    rand(4)
  end
  
  def count_game_votes
    
  end
end
