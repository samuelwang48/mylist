class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.integer :user_id
      t.integer :todo_id
      t.integer :item_id
      t.text :event
      t.boolean :method_phone_def, :default => 0
      t.boolean :method_email_def, :default => 0
      t.boolean :method_email_alt, :default => 0
      t.timestamp :occurence
      t.integer :seconds_before

      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
