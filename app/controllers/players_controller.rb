class PlayersController < ApplicationController
  layout false
  
  def index
    @players = Player.all
    
    respond_to do |format|
      format.html {render :html => @players }
      format.json {render :json => @players}
    end
  end
  
  def show
    @player = Player.find(params[:id])
  end
  
end
