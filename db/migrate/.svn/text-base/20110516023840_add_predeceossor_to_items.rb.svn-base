class AddPredeceossorToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :predecessor, :integer, :default => nil
  end

  def self.down
    remove_column :items, :predecessor
  end
end
