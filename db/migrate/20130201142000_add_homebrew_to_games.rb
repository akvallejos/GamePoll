class AddHomebrewToGames < ActiveRecord::Migration
  def change
    add_column :games, :homebrew, :boolean
  end
end
