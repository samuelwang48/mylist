class CreateContactFields < ActiveRecord::Migration
  def self.up
    create_table :contact_fields do |t|
      t.integer :contact_id
      t.text :name
      t.text :value
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_fields
  end
end
