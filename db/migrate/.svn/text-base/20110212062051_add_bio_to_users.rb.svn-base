class AddBioToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:bio, :text, :default => ''
  end

  def self.down
    remove_column :users, :bio
  end
end
