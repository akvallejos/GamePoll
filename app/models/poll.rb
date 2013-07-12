require 'assignment'

class Poll < ActiveRecord::Base
  attr_accessible :players_attributes, :ballots_attributes, :voting
  
  has_many :ballots
  has_many :players, :through => :ballots, :uniq => true
  has_many :games, :through => :ballots, :uniq => true
  
  accepts_nested_attributes_for :ballots, :players
  
    
  def winner
    rankings.first.name
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
    end #games.each
    rankings.compact.reverse
  end #rankings
  
  def assignments
    if(players.size <= rankings.first.max_players)
      return [Assignment.new(rankings.first, players.uniq)]
    else
      supported_games = games_that_support_all_players
      return assign_players(supported_games)
    end #if-else
  end #assignments
  
  def self.random_game(num_players)
    Game.where("min_players <= ? AND max_players >= ?", num_players, num_players).to_a.shuffle.shift
  end #self.random_game
  
private

  def games_that_support_all_players
    tmp_games = rankings
    supported_players = 0
    supported_games = []
    while supported_players < players.length
      supported_games = min_players_supported(supported_games, tmp_games.shift) 
      supported_players = supported_games.inject(0) { |sum, g| sum += g.max_players }
    end #while
    return supported_games
  end #games_that_support_all_players
  
  def min_players_supported(current_games, new_game)
    current_games << new_game
    min_supported = current_games.inject(0){|sum, g| sum += g.min_players }
    if min_supported <= players.size
      return current_games
    else
      current_games.pop
      return current_games
    end
  end
  
  def assign_players(supported_games)
    @unassigned = players.collect{|p| p.id}
    assigned_games = [] #supported_games.collect{|g| Assignment.new(g)}
    
  
    grouped_ballots = ballots.group_by(&:game)
    supported_games.each do |g|
      assigned_players = grouped_ballots[g].collect{ |b| b.player }
      assigned_games << Assignment.new(g, assigned_players)
      assigned_players.each {|p| @unassigned.delete(p.id) }
    end #assignments
    #puts unassigned
    if @unassigned.size > 0
      assigned_games.collect!{|a| add_unassigned_to_under_strength_games(a)}
    end
    assigned_games
  end
  
  def add_unassigned_to_under_strength_games(assignment)
    if assignment.game.min_players > assignment.players.size
      needed = assignment.game.max_players - assignment.players.size
      (0...needed).each do
        assignment.players.push(Player.find(@unassigned.pop)) unless @unassigned.empty?
      end
    end
    return assignment
  end
  
end
    
    