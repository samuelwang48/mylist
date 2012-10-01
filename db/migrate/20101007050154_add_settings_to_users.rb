class AddSettingsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:firstname,:string
    add_column :users,:lastname,:string
    add_column :users,:country,:integer
    add_column :users,:phone_mobile,:string
    add_column :users,:email_alt,:string
    
  end

  def self.down
    remove_column :users,:firstname
    remove_column :users,:lastname
    remove_column :users,:country
    remove_column :users,:phone_mobile
    remove_column :users,:email_alt
  end
end
