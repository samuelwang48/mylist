class Image < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :raw=> ["400x400>", :jpg], :large => ["128x128>", :jpg], :medium => ["52x52>", :jpg], :small => ["20x20>", :jpg] }, :path => AVATAR_PATH+"/:style/:id.:extension", :url=> AVATAR_URL+"/large/:id.:extension"
  attr_accessor :avatar_file_name
  validates_attachment_presence :avatar
#  validates_attachment_size :avatar, :less_than => 5.megabytes
#  validates_attachment_content_type :avatar, :content_type=> ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']
end
