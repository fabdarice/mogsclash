class CreateFeednews < ActiveRecord::Migration
  def change
    create_table :feednews do |t|
      t.text :content
      t.timestamps
    end
  end
end
