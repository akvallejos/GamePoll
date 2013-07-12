class PollsController < ApplicationController
  layout false
  
  def index
    @polls = Poll.where(:voting => nil).reverse 
  end
  
  def ranked
    @polls = Poll.where(:voting => 'ranked').reverse
  end
  
  def random
    num_players = params[:num_players]
    @game = Poll.random_game(num_players)
  end
  
  def new
    @poll = Poll.new
    @voting= params[:voting]
  end
  
  def create
    @poll = Poll.new
    
    @params = (params[:poll])
    @params.keys.each do |player|
      next if player == 'ballot'
      next if player == 'voting'
      p = Player.find_by_name(player)
      p ||= Player.create(:name => player)
      games = []
      @params[player].collect {|g| games << Game.find(g[:game_id])}
      
      voting_type = (@params[:voting] ||= '')
      if(voting_type == 'ranked')
        @poll.voting = 'ranked'
        @poll.ballots << p.ranked_votes(games)
      else
        @poll.ballots << p.votes(games)
      end #if-else
    end
    
    respond_to do |format|
      if @poll.save
        format.js
      else
        format.js
      end
    end
  end #create
  
  def show
    @poll = Poll.find(params[:id])
  end
  
end
