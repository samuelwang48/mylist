class TodoController < ApplicationController
  layout "master", :except => []
  before_filter :authentication
  
  verify :method => :post, :only => []
  before_filter :caching_objects
  
  private
  def caching_objects
    
  end
  
  def flush_cached_objects
    
    caching_objects()
  end
  
  public
  def start_tracking
    r = Tracking.find(:first, :conditions=>["user_id = ? and todo_id = ? and accepted = 1 and init_user_id = ?", @user.id, params[:id], @user.id])
    
    if r.blank?
      tracking = Tracking.new()
      tracking.user_id = @user.id
      tracking.todo_id = params[:id]
      tracking.todo_user_id = Todo.find(params[:id]).user.id
      tracking.accepted = 1
      tracking.init_user_id = @user.id
      tracking.save
    end
    
    site_log = SiteLog.new()
    site_log.user_id = session[:user_id]
    site_log.todo_id = params[:id]
    site_log.log_type = "start_tracking"
    site_log.ip = request.remote_ip
    site_log.save()
    
    render :text => ''.to_json
  end
  
  def stop_tracking
    r = Tracking.find(:first, :conditions=>["user_id = ? and todo_id = ? and accepted = 1 and init_user_id = ?", @user.id, params[:id], @user.id])
    
    if !r.blank?
      r.destroy
    end
    
    site_log = SiteLog.new()
    site_log.user_id = session[:user_id]
    site_log.todo_id = params[:id]
    site_log.log_type = "stop_tracking"
    site_log.ip = request.remote_ip
    site_log.save()
    
    render :text => ''.to_json
  end
  
  def item_done
    @item = Item.find(params[:id])
    
    @user_auth = get_auth(@item.todo)
    
    if @user_auth['w'] == false
      render :text => 'you are not authorized to modify this'
    else
      if @item.todo.user.id = session[:user_id]
        @item.update_attributes({:is_finished, true})
        @item.todo.update_attributes({:modified_at, Time.zone.now})
      end
      render :nothing => true
    end
  end
  
  def item_undo
    @item = Item.find(params[:id])
    
    @user_auth = get_auth(@item.todo)
    
    if @user_auth['w'] == false
      render :text => 'you are not authorized to modify this'
    else
      if @item.todo.user.id = session[:user_id]
        @item.update_attributes({:is_finished, false})
        @item.todo.update_attributes({:modified_at, Time.zone.now})
      end
      render :nothing => true
    end
  end
  
  def savePermissions
    todo_id = params[:id]
    list = Todo.find(todo_id)
    
    @user_auth = get_auth(list)
    
    if @user_auth['w'] == false
      render :text => 'you are not authorized to modify this'
    else
      permissions = ActiveSupport::JSON.decode(params[:contacts])
      
      permissions.each{|p|
        permission = TodoPermission.find(:all, :conditions=>["todo_id=? and contact_id=?", todo_id, p['cid']]) 
  
        if permission.size == 0
          permission = TodoPermission.new
          permission.todo_id = todo_id
          permission.contact_id = p['cid']
          permission.r = p['r']
          permission.w = p['w']
          permission.d = p['d']
          permission.save()
        else
          permission = permission[0]
          permission.r = p['r']
          permission.w = p['w']
          permission.d = p['d']
          permission.save()
        end
        
        if p['cid'].to_i > 0 && p['r'] == true
          contact = Contact.find(p['cid'].to_i)
          if contact.local_user_id > 0
            r = Tracking.find(:first, :conditions=>["user_id = ? and todo_id = ?", contact.local_user_id, todo_id])
            if r.blank?
              tracking = Tracking.new()
              tracking.user_id = contact.local_user_id
              tracking.todo_id = todo_id
              tracking.todo_user_id = Todo.find(todo_id).user.id
              tracking.accepted = 0
              tracking.init_user_id = @user.id
              tracking.message = params[:msg]
              tracking.save
            end
          end
        end
      }
      
      
      render :text => ''.to_json, :layout => false
    end
  end
  
  def new
    @todo = params[:id].blank? ? Todo.new : Todo.find(params[:id])
    @todo.saved_from = @todo.id
    @todo.user_id = @user.id
    
    @user_auth = get_auth(@todo)
    
  end
  
  def delete
    @todo = Todo.find(params[:id])
    @user_auth = get_auth(@todo)
    
    if @user_auth['w'] == false
      render :text => 'you are not authorized to modify this'
    else
      site_log = SiteLog.new()
      site_log.user_id = session[:user_id]
      site_log.todo_id = @todo.id
      site_log.log_type = "delete_list"
      site_log.ip = request.remote_ip
      site_log.save()
      
      @todo.destroy
      render :text => ''.to_json, :layout => false
    end
  end

  def edit
    @todo = Todo.find(decode(params[:id]))
    
    @user_auth = get_auth(@todo)
    @user_tracking = !Tracking.find(:first, :conditions=>["todo_id = ? and user_id = ? and accepted = 1", @todo.id, @user.id]).blank?
    
    if @user_auth['r'] == false
      render :text => 'you are not authorized to read this'
    else
      if @user.id != @todo.user_id
        @todo.update_attribute(:reads, @todo.reads+1)
      end
      @title = @todo.name
    end
  
  end

  def create
    @todo = Todo.new(params[:todo])
    @todo.saved_from = decode(params[:todo][:saved_from])
    @todo.name = @todo.name == '' ? 'Untitled Todo' : @todo.name
    @todo.modified_at = Time.zone.now
    
    if @todo.save
      items = params[:items]
      i = 0
      items.each_pair {| key_, value |
        key_ = key_.split('_')
        key = key_[0]
        sort = key_[1]
        is_finished = key_[2]
        #pp is_finished
        pp key.to_s+"|"+sort.to_s
        if key.to_i > 0 
          
        else
            item = Item.new()
            item.sort = sort
            item.description = value
            item.todo_id = @todo.id
            item.is_finished = is_finished
            item.save()
        end
      }
      
      permissions = ActiveSupport::JSON.decode(params[:permission])
      
      permissions.each{|p|
        permission = TodoPermission.find(:all, :conditions=>["todo_id=? and contact_id=?", @todo.id, p['cid']]) 
  
        if permission.size == 0
          permission = TodoPermission.new
          permission.todo_id = @todo.id
          permission.contact_id = p['cid']
          permission.r = p['r']
          permission.w = p['w']
          permission.d = p['d']
          permission.save()
        else
          permission = permission[0]
          permission.r = p['r']
          permission.w = p['w']
          permission.d = p['d']
          permission.save()
        end
        
        if p['cid'].to_i > 0 && p['r'] == true
          contact = Contact.find(p['cid'].to_i)
          if contact.local_user_id > 0
            r = Tracking.find(:first, :conditions=>["user_id = ? and todo_id = ?", contact.local_user_id, @todo.id])
            if r.blank?
              tracking = Tracking.new()
              tracking.user_id = contact.local_user_id
              tracking.todo_id = @todo.id
              tracking.todo_user_id = Todo.find(@todo.id).user.id
              tracking.accepted = 0
              tracking.init_user_id = @user.id
              tracking.message = params[:msg]
              tracking.save
            end
          end
        end
      }
      
      site_log = SiteLog.new()
      site_log.user_id = session[:user_id]
      site_log.todo_id = @todo.id
      if !@todo.saved_from.blank?
        site_log.saved_todo_id = @todo.saved_from
        site_log.log_type = "new_list_saved_fr"
      else
        site_log.log_type = "new_list"
      end
      
      site_log.ip = request.remote_ip
      site_log.save()
      
      flash[:notice] = 'Todo was successfully created.'

      redirect_to "/todo/edit/" + encode(@todo.id)
    end
  end
  
  def save
    items = ActiveSupport::JSON.decode params[:items]
    @todo = Todo.find(params[:id])
    
    @user_auth = get_auth(@todo)
    
    if @user_auth['w'] == false
      render :text => 'you are not authorized to save this'
    else
      delete_todo_items = @todo.items.collect{|itm|itm.id}
      
      new_items = []
      items.each {| i |
        key_ = i[0].split('_')
        value = i[1]
        key = key_[1]
        sort = key_[2]
        is_finished = key_[3]
        if key.to_i > 0
          if value.strip.size > 0
            Item.update(key, { :description => value, :sort => sort })#CGI.unescape(value)
          end
          delete_todo_items.delete(key.to_i)
        else
          item = Item.new()
          item.sort = sort
          item.description = value#CGI.unescape(value)
          item.todo_id = @todo.id
          item.is_finished = is_finished
          item.save()
          new_items.push(item)
        end
      }
      
      delete_todo_items.each{|d|
        Item.destroy(d)
      }
      
      @todo.update_attributes ActiveSupport::JSON.decode(params[:todo])
      @todo.update_attribute(:modified_at, Time.zone.now)
      
      site_log = SiteLog.new()
      site_log.user_id = session[:user_id]
      site_log.todo_id = @todo.id
      site_log.log_type = "update_list"
      site_log.ip = request.remote_ip
      site_log.save()
      
      render :text => new_items.to_json, :layout => false
    end
    
  end
  
  def set_duration
    @item = Item.find(params[:item_id])
    
    @user_auth = get_auth(@item.todo)
    
    if @user_auth['w'] == false
      render :text => 'you are not authorized to modify this'
    else
      @item.update_attributes({:start => params[:start], :due => params[:due]})
      
      render :text => {:start => params[:start], :due => params[:due]}.to_json, :layout => false
    end
  end
  
  def set_predecessor
    @item = Item.find(params[:item_id])
    
    @user_auth = get_auth(@item.todo)
    
    if @user_auth['w'] == false
      render :text => 'you are not authorized to modify this'
    else
      @item.update_attributes({:predecessor => params[:predecessor]})
      
      render :text => {:predecessor => params[:predecessor]}.to_json, :layout => false
    end
  end
end
