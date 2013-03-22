class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.references :player
      t.references :game
      t.references :poll
          

      t.timestamps
    end
  end
end
