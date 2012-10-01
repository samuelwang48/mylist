class AddSavedFromToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :saved_from, :integer, :default => 0
  end

  def self.down
    remove_column :todos, :saved_from
  end
end
