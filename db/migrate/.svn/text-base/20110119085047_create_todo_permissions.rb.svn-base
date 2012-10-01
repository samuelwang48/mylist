class CreateTodoPermissions < ActiveRecord::Migration
  def self.up
    add_column :todos, :deleted_at, :datetime
    create_table :todo_permissions do |t|
      t.integer :todo_id
      t.integer :contact_id #public:-1
      t.boolean :r, :default => 0
      t.boolean :w, :default => 0
      t.boolean :d, :default => 0
      t.timestamps
    end
    
  end

  def self.down
    remove_column :todos, :deleted_at
    drop_table :todo_permissions
  end
end
