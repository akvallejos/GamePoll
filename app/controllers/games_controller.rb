class GamesController < ApplicationController
  layout false
  
  def index
    @games = Game.order("name")
  end

  def new
    @game = Game.new
  end
  
  def create
    @game = Game.new(params[:game])
    
    respond_to do |format|
      if @game.save
        format.js
      else
        format.js
      end
    end
  end #create
  
  def refresh
  end  
  
  def edit
    @game = Game.find(params[:id])
  end
  
  def update
    @game = Game.find(params[:id])
    
    if @game.update_attributes(params[:id])
      redirect_to games_path, :notice => 'Game successfuly updated'
    else
      render :action => 'edit'
    end
  end
end
