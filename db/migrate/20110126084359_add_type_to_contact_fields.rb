class AddTypeToContactFields < ActiveRecord::Migration
  def self.up
    add_column :contact_fields, :ftype, :integer #types refer to environment.rb
  end

  def self.down
    remove_column :contact_fields, :ftype
  end
end
