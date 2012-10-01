class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :local_user_id#if this contact is itodo.it user then this field holds the value of his user_id
      t.text :prefix
      t.text :first
      t.text :middle
      t.text :last
      t.text :suffix
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
