class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.text :description
      t.boolean :is_finished, :default => 0
      t.integer :todo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
