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
  
  def edit
    @game = Game.find(params[:id])
  end
  
  def update
    @game = Game.find(params[:id])
    
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.js
      else
        render :action => 'edit'
      end
    end #respond_to
  end #update
  
end
