class Tracking < ActiveRecord::Base
  belongs_to :user
  belongs_to :todo
  
  protected
  def before_destroy
    
  end
  
  public
  def init_user
    User.find(init_user_id)
  end
end
