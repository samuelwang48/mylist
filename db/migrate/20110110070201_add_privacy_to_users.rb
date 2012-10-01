class AddPrivacyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :searchable, :boolean, :default => 1
    add_column :users, :profile_visible, :integer, :default => 1
  end

  def self.down
    remove_column :users, :profile_visible
    remove_column :users, :searchable
  end
end
