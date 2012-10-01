class AddReadsToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :reads, :integer, :default => 0
  end

  def self.down
    remove_column :todos, :reads
  end
end
