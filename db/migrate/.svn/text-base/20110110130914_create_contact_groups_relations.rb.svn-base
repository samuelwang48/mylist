class CreateContactGroupsRelations < ActiveRecord::Migration
  def self.up
    create_table :contact_groups_relations do |t|
      t.integer :contact_id
      t.integer :contact_group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_groups_relations
  end
end
