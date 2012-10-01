class Reminder < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :item
  belongs_to :todo
  belongs_to :user
  
end
