class Todo < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  
  has_many :items, :order => 'sort ASC', :dependent => :destroy
  has_many :reminders, :dependent => :destroy
  has_many :todo_permissions, :dependent => :destroy
  has_many :trackings
  
  def finished
    Item.find(:all, :conditions=>["todo_id = (?) and is_finished = 1", id])
  end

  def unfinished
    Item.find(:all, :conditions=>["todo_id = (?) and is_finished = 0", id])
  end
  
  def permission_public
    TodoPermission.find(:first, :conditions=>["todo_id = (?) and contact_id = -1", id])
  end
  
  def permission_mycontacts
    TodoPermission.find(:first, :conditions=>["todo_id = (?) and contact_id = -2", id])
  end
  
  def permission_contact user_id
    TodoPermission.find_by_sql ["select * from todo_permissions as p inner join contacts as c on (c.id = p.contact_id and p.todo_id = ? and local_user_id = ? and p.deleted_at IS NULL)", id, user_id]
  end
  
  def permission_contacts
    TodoPermission.find_by_sql ["select * from todo_permissions as p inner join contacts as c on (c.id = p.contact_id and p.todo_id = ? and (p.r=true or p.w=true or p.d=true) and p.deleted_at IS NULL)", id]
  end
  
  def duration
    #["select min(start), max(due) from items as i where i.todo_id = ?", id]
    res = ActiveRecord::Base.connection.execute("select min(start), max(due) from items as i where i.todo_id = " + id.to_s).extend(Enumerable).to_a
    start = res[0][0]
    due = res[0][1]
    {'start' => start, 'due' => due}
  end
  
  
  def savers
    Todo.find(:all, :conditions=>["saved_from = ? ", id])
  end
end
