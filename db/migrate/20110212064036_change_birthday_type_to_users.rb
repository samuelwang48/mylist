class ChangeBirthdayTypeToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :birthday
    add_column :users, :birthday, :string
  end

  def self.down
  end
end
