class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :contact_id
      t.integer :invitation_type #1 for new user, 0 for existing user
      t.text :token
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
