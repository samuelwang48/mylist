class TodoPermission < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :todo
  
end
