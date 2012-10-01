class AddDetailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :birthday, :integer
    add_column :users, :url, :string
    add_column :users, :position, :string
    add_column :users, :occupation, :string
    add_column :users, :sex, :integer
  end

  def self.down
    remove_column :users, :sex
    remove_column :users, :occupation
    remove_column :users, :position
    remove_column :users, :url
    remove_column :users, :birthday
  end
end
