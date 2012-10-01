class AddMessageToTrackings < ActiveRecord::Migration
  def self.up
    add_column :trackings, :message, :text, :default => ''
  end

  def self.down
    remove_column :trackings, :message
  end
end
