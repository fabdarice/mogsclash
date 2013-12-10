class CreateGames < ActiveRecord::Migration
  def change
    create_table :games, :force => true do |t|
      t.integer :user_id, :null => false
      t.integer :challenger_id, :null => false
      t.integer :winner_id
      t.string :user_1_champ
      t.string :user_2_champ
      t.integer :user_1_score
      t.integer :user_2_score
      t.string :status
      t.timestamps
    end
  end
end
