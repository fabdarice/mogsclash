class AddPointDiffToGame < ActiveRecord::Migration
  def change
    add_column :games, :points_diff, :integer
  end
end
