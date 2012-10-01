class AddAcceptedToTrackings < ActiveRecord::Migration
  def self.up
    add_column :trackings, :accepted, :integer
    add_column :trackings, :init_user_id, :integer
    begin
    Tracking.find_by_sql ["delete from trackings where id >= 0"]
    rescue
    end
  end

  def self.down
    remove_column :trackings, :accepted
    remove_column :trackings, :init_user_id
  end
end
