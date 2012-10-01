class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :user_id
      t.string :image_type
      t.string :path
      t.string :url
      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
