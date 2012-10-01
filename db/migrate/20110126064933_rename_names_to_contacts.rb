class RenameNamesToContacts < ActiveRecord::Migration
  def self.up
    rename_column :contacts, :first, :firstname
    rename_column :contacts, :last, :lastname
    remove_column :contacts, :prefix
    remove_column :contacts, :middle
    remove_column :contacts, :suffix
  end

  def self.down
    rename_column :contacts, :firstname, :first
    rename_column :contacts, :lastname, :last
    add_column :contacts, :prefix, :string
    add_column :contacts, :middle, :string
    add_column :contacts, :suffix, :string
  end
end
