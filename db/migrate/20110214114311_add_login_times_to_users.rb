class AddLoginTimesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :login_times, :integer, :default => 0
  end

  def self.down
    remove_column :users, :login_times
  end
end
