class AddModifiedAtToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :modified_at, :datetime, :default => nil
    
    Todo.find(:all).each do |t|
      t.modified_at = t.created_at
      t.save()
    end
  end

  def self.down
    remove_column :todos, :modified_at
  end
end
