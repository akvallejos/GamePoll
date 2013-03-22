class AddVotingToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :voting, :string 
  end
end
