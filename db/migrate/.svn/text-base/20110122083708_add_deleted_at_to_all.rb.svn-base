class AddDeletedAtToAll < ActiveRecord::Migration
  def self.up
    add_column :contacts, :deleted_at, :datetime
    add_column :contact_fields, :deleted_at, :datetime
    add_column :contact_groups, :deleted_at, :datetime
    add_column :contact_groups_relations, :deleted_at, :datetime
    add_column :items, :deleted_at, :datetime
    add_column :reminders, :deleted_at, :datetime
    add_column :todo_permissions, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime
  end

  def self.down
    remove_column :contacts, :deleted_at
    remove_column :contact_fields, :deleted_at
    remove_column :contact_groups, :deleted_at
    remove_column :contact_groups_relations, :deleted_at
    remove_column :items, :deleted_at
    remove_column :reminders, :deleted_at
    remove_column :todo_permissions, :deleted_at
    remove_column :users, :deleted_at
  end
end
