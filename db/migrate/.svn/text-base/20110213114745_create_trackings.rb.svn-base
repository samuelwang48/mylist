class CreateTrackings < ActiveRecord::Migration
  def self.up
    create_table :trackings do |t|
      t.integer :user_id
      t.integer :todo_id
      t.integer :todo_user_id
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :trackings
  end
end
