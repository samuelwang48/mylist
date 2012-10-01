class User < ActiveRecord::Base
  acts_as_paranoid
  
  attr_accessor :password_confirmation
  attr_accessor :tab
  attr_accessor :password_old
  
  has_many :todos, :order => "created_at DESC" 
  has_one :default_todo, :class_name => "Todo", :primary_key => "default_todo_id", :foreign_key => "id"
  has_many :contact_groups
  has_many :contacts
  has_many :invitations
  has_many :trackings
  has_many :site_logs, :order => "created_at ASC" 

protected
  def validate_on_create
    if email.blank?
      errors.add("1Email", "can't be blank")
    else
      if email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
        r = User.find(:first, :conditions=>["email = ?", email])
        if r
          errors.add("1Email", "has been taken already")
        end
      else
        errors.add("1Email", "has a wrong format")
      end
    end
    
    errors.add("2Firstname", "can't be blank") unless !firstname.blank?
    errors.add("3Lastname", "can't be blank") unless !lastname.blank?
    
    if password.blank?
      errors.add("4Password", "can't be blank")
    else
      if password.size >= 6 && password.size <= 40
        if password != password_confirmation
          errors.add("4Password confirmation", "doesn't match")
        end
      else
        errors.add("4Password", "is too short") if password.size < 6
        errors.add("4Password", "is too long") if password.size > 40
      end
    end
  end
  
  def validate_on_update
    if tab == 'profile'
      if !username.blank?
        if username =~ /^[a-z]{1}[a-z0-9_]{3,19}$/
          r = User.find(:first, :conditions=>["username = ? and id <> ?", username, id])
          if r
            errors.add("1itodo.it ID", "has been taken already")
          end
        else
          errors.add("1itodo.it ID", "shall start with a-z and only contain numbers and underscore and all in lowercase. Max length is 20, Min length is 4")
        end
      end
      
      errors.add("2Firstname", "can't be blank") unless !firstname.blank?
      errors.add("3Lastname", "can't be blank") unless !lastname.blank?
      
      if sex == 0 || sex == 1
        
      else
        errors.add("4Gender", "has unexpected value")
      end
      
      if !birthday.blank?
        if birthday.to_s =~ /^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/
          
        else
          errors.add("5Birthday", "has unexpected value")
        end
      end
      
      if !url.blank?
        if url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
        
        else
          errors.add("6URL", "has a wrong format")
        end
      end
      
    elsif tab == 'password'
      if !password_old.blank?
        r = User.find(:first, :conditions=>["password = ? and id = ?", password_old, id])
        
        if r.blank?
          errors.add("1Your old password", "is wrong")
        else
          if password.blank?
            errors.add("2Your new password", "can't be blank")
          else
            if password.size >= 6 && password.size <= 40
              if password != password_confirmation
                errors.add("3New password confirmation", "doesn't match")
              end
            else
              errors.add("4New password", "is too short") if password.size < 6
              errors.add("4New Password", "is too long") if password.size > 40
            end
          end
        end
      else
        errors.add("1Your old password", "is required")
      end
    elsif tab == 'mobile'
      if !phone_mobile.blank?
        if phone_mobile.to_s =~ /^1[0-9]{10}$/
          
        else
          errors.add("1Mobile Phone", "should be 11 digit")
        end
      end
      
      if !email_alt.blank?
        if email_alt.to_s =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
          
        else
          errors.add("2Alternative Email", "has a wrong format")
        end
      end
    else
      
    end
  end
  
public
  
  def items_total
    return Item.count_by_sql(["select count(*) from items as i where i.deleted_at IS NULL and i.todo_id in (select t.id from todos as t where t.user_id=?)", id])
  end
  
  def open_items_total
    return Item.count_by_sql(["select count(*) from items as i where i.deleted_at IS NULL and i.todo_id in (select t.id from todos as t where t.user_id=?) and (i.is_finished IS NULL or i.is_finished=0) ", id])
  end
  
  def closed_items_total
    return Item.count_by_sql(["select count(*) from items as i where i.deleted_at IS NULL and i.todo_id in (select t.id from todos as t where t.user_id=?) and i.is_finished=1", id])
  end
  
  def trackers
    User.find_by_sql ["select distinct u.id from users as u inner join trackings as t on (t.todo_user_id=? and u.id=t.user_id and t.accepted = 1)", id]
  end
  
  def pending_trackings
    Tracking.find_by_sql ["select r.* from todos as t inner join trackings as r on (r.todo_id=t.id and r.user_id=? and r.accepted = 0) order by created_at desc", id]
  end
  
  def connections
    Contact.find(:all, :conditions => ["user_id = ? and local_user_id > 0", id])
  end
  
  def self.tracking_todos id
    return Todo.find_by_sql ["select t.* from todos as t inner join trackings as r on (r.todo_id=t.id and r.user_id=? and r.accepted = 1)", id]
  end
  
  def self.home_more_lists num, user_id
    Todo.all(:limit => ITODO_HOME_LIST_SIZE, :offset => ITODO_HOME_LIST_SIZE*(num.to_i), :order => "modified_at desc", :conditions => ["user_id = (?)", user_id])
  end
  
  def self.home_more_trackings num, user_id
    Todo.find_by_sql ["select distinct t.* from todos as t inner join trackings as k on (k.todo_id = t.id and k.accepted = 1 and k.user_id = ? and t.deleted_at IS NULL) order by k.created_at desc limit ?, ?;", user_id, ITODO_HOME_LIST_SIZE*(num.to_i), ITODO_HOME_LIST_SIZE]
  end
  
  def self.profile_more_lists num, user_id, visitor_id
    Todo.find_by_sql ["SELECT distinct t.* FROM todos as t inner join todo_permissions as p on (t.user_id = ? and t.deleted_at IS NULL and p.todo_id = t.id  and p.r = 1 and (p.contact_id = -1 or p.contact_id = -2 or p.contact_id = (SELECT distinct c.id from contacts as c where c.local_user_id = ? and c.user_id = ? and c.deleted_at IS NULL))) order by t.modified_at desc limit ?, ?;", user_id, visitor_id, user_id, ITODO_HOME_LIST_SIZE*(num.to_i), ITODO_HOME_LIST_SIZE]
  end
  
  def self.profile_more_trackings num, user_id, visitor_id
    Todo.find_by_sql ["SELECT distinct t.* FROM todos as t inner join todo_permissions as p inner join trackings as k on (t.deleted_at IS NULL and p.todo_id = t.id  and p.r = 1 and (p.contact_id = -1 or p.contact_id = -2 or p.contact_id = (SELECT distinct c.id from contacts as c where c.user_id = ? and c.local_user_id = ? and c.deleted_at IS NULL)) and k.todo_id = t.id and k.user_id = ? and k.accepted = 1) order by k.created_at desc limit ?, ?;", user_id, visitor_id, user_id, ITODO_HOME_LIST_SIZE*(num.to_i), ITODO_HOME_LIST_SIZE]
  end
  
  def self.default_size
    ITODO_HOME_LIST_SIZE
  end
  
  def self.is_contact? user_id, contact_id
    User.find(user_id).contacts.collect{|c|c.local_user_id}.include?(contact_id)
  end

  def avatar_url size
    image = Image.find(:first, :conditions=>["user_id = ?", id])
    if !image.blank?
      AVATAR_URL + "/" +size + "/" + image.id.to_s + ".jpg"
    else
      ""
    end
  end

  def avatar_path size
    image = Image.find(:first, :conditions=>["user_id = ?", id])
    AVATAR_PATH + "/" +size + "/" + image.id.to_s + ".jpg"
  end
  
end
