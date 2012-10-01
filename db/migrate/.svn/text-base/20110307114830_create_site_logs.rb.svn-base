class CreateSiteLogs < ActiveRecord::Migration
  def self.up
    create_table :site_logs do |t|
      t.integer :user_id
      t.integer :local_user_id
      t.integer :todo_id
      t.integer :saved_todo_id
      t.integer :item_id
      t.integer :reminder_id
      t.integer :contact_id
      t.integer :todo_permission_id
      t.integer :tracking_id
      
      t.text :log_type #see def log_for in appplication.rb
      t.text :ip
      
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :site_logs
  end
end
