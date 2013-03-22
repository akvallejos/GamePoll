require 'assignment'

class Poll < ActiveRecord::Base
  attr_accessible :players_attributes, :ballots_attributes, :voting
  
  has_many :ballots
  has_many :players, :through => :ballots, :uniq => true
  has_many :games, :through => :ballots, :uniq => true
  
  accepts_nested_attributes_for :ballots, :players
  
    
  def winner
    rankings.last.name
  end #winner
  
  
  def votes_for(game)
    score = 0
    ballots.where(:game_id => game.id).each do |b|
      score += b.weight
    end
    score
  end #votes_for
  
  def rankings
    rankings = []
    games.each do |game|
      score = votes_for(game)
      rankings.insert((score*100).to_i, game) # * 10 captures fractional differences
    end #names.uniq
    rankings.compact
  end #rankings
  
  def assignments
    if(players.size <= rankings.last.max_players)
      return [Assignment.new(rankings.last, players.uniq)]
    else
      @a = Array.new
      assign_players
      check_for_min_players
      add_unassigned
      return @a
    end #if-else
  end #assignments
  
private

  def assign_players
    index = -1
    while unassigned.length > 0
      p = ballots.where(:game_id => rankings[index].id).collect{ |b| b.player }
      @a << Assignment.new(rankings[index], p)
      index -= 1
    end #while
  end
  
  def check_for_min_players
    @a.each do |x|
      if x.players.size < x.game.min_players
        @a[@a.index(x) - 1].players << x.players.flatten.uniq
        @a.delete(x)
        check_for_min_players
      end #if
    end #a.each
  end #check_for_min_players
  
  def unassigned
    players - @a.collect{ |x| x.players}.flatten
  end #unassigned
  
  def add_unassigned
    @a.each do |g|
      unassigned.each do |p|
        g.players << p if g.players.size < g.game.max_players
      end
    end
  end #add_unassigned
end
    
    