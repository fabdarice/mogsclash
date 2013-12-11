class AddPointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :points, :integer, :default => 900
  end
end
