class AddDefaultValueToScore < ActiveRecord::Migration
  def up
    change_column :games, :user_1_score, :integer, :default => 0
    change_column :games, :user_2_score, :integer, :default => 0
  end

  def down
    change_column :games, :user_1_score, :integer, :default => nil
    change_column :games, :user_2_score, :integer, :default => nil
  end
end
