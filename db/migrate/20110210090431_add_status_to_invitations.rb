class AddStatusToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :status, :integer, :default => 1
    
    Invitation.find(:all).each do |inv|
      inv.status = 1
      inv.save()
    end
  end

  def self.down
    remove_column :invitations, :status
  end
end
