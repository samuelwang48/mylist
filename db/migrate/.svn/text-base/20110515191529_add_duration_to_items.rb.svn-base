class AddDurationToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :start, :datetime, :default => nil
    add_column :items, :due, :datetime, :default => nil
  end

  def self.down
    remove_column :items, :start
    remove_column :items, :due
  end
end
