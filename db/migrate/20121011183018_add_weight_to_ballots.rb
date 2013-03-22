class AddWeightToBallots < ActiveRecord::Migration
  def self.up
    add_column :ballots, :weight, :float
  end
  
  def self.down
    remove_column :ballots, :weight
  end
end
