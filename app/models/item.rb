class Item < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :todo
  has_one :reminder
  
  def has_reminder?
    !self.reminder.blank?
  end
  
  def duration
   if !due.blank? && !start.blank?
     sub = (due - start)/1.day
     sub <= 0 ? 0 : sub.to_i
   else
     0
   end
  end
  
end
