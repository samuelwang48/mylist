class WebController < ApplicationController
  layout "master", :except => []
  before_filter :authentication, :except=>[:index, :invite, :join, :join_beta, :account_created, :account_activation, :login, :logout, :authenticate]
  before_filter :redirect_session, :only=>[:index, :invite, :join, :join_beta, :account_created, :account_activation]
  
  private
  def redirect_session
    if session[:user_id]
      redirect_to :controller=>"web", :action=>"home"
    end
  end
  
  public
  def accept_tracking
    tracking = Tracking.find(decode(params[:id]))
    if params[:accepted].to_i == 1
      tracking.update_attribute(:accepted, 1)
      
      site_log = SiteLog.new()
      site_log.user_id = session[:user_id]
      site_log.todo_id = tracking.id
      site_log.log_type = "accept_tracking"
      site_log.ip = request.remote_ip
      site_log.save()
    else
      tracking.destroy
      
      site_log = SiteLog.new()
      site_log.user_id = session[:user_id]
      site_log.todo_id = tracking.id
      site_log.log_type = "ignore_tracking"
      site_log.ip = request.remote_ip
      site_log.save()
    end
    
    render :text => ''
  end
  
  def index
    if !cookies[:RL].blank?
     redirect_to "/web/home"
    end
  end
  
  def profile
    @id = decode(params[:id])
    
    if @id.to_i > 0
      @user = User.find(@id)
    else
      @user = User.find(:first, :conditions => [ "username = ?", params[:id]])
    end
    
    if @user.blank?
      render :text => 'no user found'
    else
      if @user.id == session[:user_id]
        #user self
      else
        if @user.profile_visible == 0
          #not verified
          render :text => 'You are not authorized to view this profile'
        elsif @user.profile_visible == 1
          #everyone can see my profile
          #do nothing
        elsif @user.profile_visible == 2
          #only my contacts can see my profile
          if User.is_contact?(@user.id, session[:user_id])
            #verified, is a contact of
          else
            #not verified
            render :text => 'You are not authorized to view this profile'
          end
        
        end
      end

    end
    
    
  end
  
  def home
    @list_selected = ''
    @tracking_selected = ''
    @log_selected = ''
    
    if cookies[:HT].blank?
      @list_selected = ' class="current"'
      @home_tab_html = render_to_string :partial => "home_tab_lists", :locals => {:lists => User.home_more_lists(0, @user.id)}
    else
      if cookies[:HT] == 'l'
        @list_selected = ' class="current"'
        @home_tab_html = render_to_string :partial => "home_tab_lists", :locals => {:lists => User.home_more_lists(0, @user.id)}
      elsif cookies[:HT] == 't'
        @tracking_selected = ' class="current"'
        @home_tab_html = render_to_string :partial => "home_tab_trackings", :locals => {:pending_trackings => @user.pending_trackings, :user_trackings => User.home_more_trackings(0, @user.id)}
      elsif cookies[:HT] == 'g'
        @log_selected = ' current'
        @home_tab_html = render_to_string :partial => "home_log_timeline", :locals => {:site_logs => @user.site_logs }
      end
    end
  end
  
  def join
    
  end
  
  def invite
    
    @error = []
    
    inv = Invitation.find(:first,:conditions=>["token = ? and status = 1", params[:id]])
    
    if inv.nil?
      @error.push('This invitation is invalid.')
    end
    
    if @error.size > 0
      render :text => @error.join('<br />')
    else
      
    end
    
  end
  
  def join_beta
    inv = Invitation.find(:first,:conditions=>["token = ? and status = 1", params[:id]])
    
    if inv.nil?
      @error.push('This invitation is invalid.')
    end
    
    @user = User.new(params[:user])
    remember_me = Digest::MD5.hexdigest((!User.last.nil? ? User.last.id+1:1).to_s + Time.now().to_i.to_s)
    @user.remember_me = remember_me

    md5 = Digest::MD5.hexdigest((!User.last.nil? ? User.last.id+1:1).to_s+'act')
    len = md5.size
    token = md5.insert(((len/4)*3).to_i, '-').insert(((len/4)*2).to_i, '-').insert(((len/4)*1).to_i, '-')
    token = token.split('-')
    token = ['a','b','c','d','e','f'][rand(6).to_i]+'-'+token[3]+'-'+token[1]+'-'+token[0]+'-'+token[2]
    
    @user.activation_code = token

    if @user.save
      new_todo = Todo.new({
        :name => 'My Meaningful Life',
        :description => 'Would the world be any different if you weren’t born? Do you wake up in the morning feeling like you have an important role to play in the grand scheme of things?',
        :user_id => @user.id,
        :modified_at => Time.zone.now
      })
      if new_todo.save
        @user.update_attribute(:default_todo_id, new_todo.id)
        
        new_item = Item.new({
          :description => 'I have successfully signed up my account on itodo.it!',
          :todo_id => new_todo.id,
          :sort => 1,
          :is_finished => true
        })
        new_item.save
        
        new_item = Item.new({
          :description => 'Visit one of the most interesting users',
          :todo_id => new_todo.id,
          :sort => 2
        })
        new_item.save
        
        permission = TodoPermission.new()
        permission.todo_id = new_todo.id
        permission.contact_id = -1
        permission.r = 1
        permission.w = 0
        permission.d = 0
        permission.save()
        
        permission = TodoPermission.new()
        permission.todo_id = new_todo.id
        permission.contact_id = -2
        permission.r = 1
        permission.w = 0
        permission.d = 0
        permission.save()
        
        inv.update_attribute(:status, 0)
        inv.contact.update_attribute(:local_user_id, @user.id)
      end

      subject = 'Account Activation'
      m = "Thank you for your time creating an account, \n"
      m = m + "Please click following link or paste it to your browser to activate your account.\n"
      m = m + 'visit '+server_host+'/account_activation/'
      
      send_email([@user.email], subject, m+token)
      
      flash[:email] = @user.email
      redirect_to :controller=>"web", :action=>"account_created"
    else
      render :action => 'invite'
    end
    
  end
  
  def account_created
    
  end

  def account_activation
    r = User.find(:first, :conditions=>["activation_code = ?", params[:id]])
    
    if !r.nil? && r.status == 0
      r.update_attribute(:status, 1)
      flash[:notice] = "You account has been successfully activated."
      redirect_to :controller=>"web", :action=>"login"
    else
      redirect_to :controller=>"web", :action=>"login"
    end
    
  end

  def login
    
  end
  
  def logout
    site_log = SiteLog.new()
    site_log.user_id = session[:user_id]
    site_log.log_type = "sign_out"
    site_log.ip = request.remote_ip
    site_log.save()
    
    session[:user_id] = nil
    if !cookies[:RL].blank?
      cookies.delete :RL
    end
    
    redirect_to :controller=>"web", :action=>"index"
  end
  
  def authenticate
    @user = User.find(:first,:conditions=>["email = ? and password = ? and status = 1",params[:user][:email],params[:user][:password]])
    

      
    if @user.nil?
      if params[:remember_login]
        cookies[:RL] = { :value => 1, :expires => 1.month.from_now }
      else
        cookies.delete :RL
      end
      
      flash[:notice] = "Please check your email and password."
      redirect_to :controller=>"web", :action=>"login"
      #render :action => "login"
    else
      @user.update_attribute(:login_times, @user.login_times+1)
      
      if params[:remember_login]
        cookies[:RL] = { :value => @user.remember_me, :expires => 1.month.from_now }
      else
        cookies.delete :RL
      end
      
      session[:user_id] = @user.id
      
      site_log = SiteLog.new()
      site_log.user_id = session[:user_id]
      site_log.log_type = "sign_in"
      site_log.ip = request.remote_ip
      site_log.save()
      
      redirect_to :controller=>"web", :action=>"home"
    end
  end
  
  def settings
    
  end
  
  def update_settings
    @user = User.find(session[:user_id])
    @user.update_attributes(ActiveSupport::JSON.decode(params[:user]))
    
    data = {}
    
    if @user.errors.empty?
      
      site_log = SiteLog.new()
      site_log.user_id = session[:user_id]
      site_log.log_type = "update_profile"
      site_log.ip = request.remote_ip
      site_log.save()
      
      render :text => ''.to_json
      return
    else
      
      data[:errors] = @user.errors
      
      render :text => data.to_json
      return
    end
    
  end
  
  def home_load_log_timeline
    
    render :partial => "home_log_timeline", :locals => {:site_logs => @user.site_logs }
  end
  
  def home_load_lists
    render :partial => "home_tab_lists", :locals => {:lists => User.home_more_lists(0, @user.id)}
  end
  
  def home_more_lists
    todo = User.home_more_lists params[:page_num], @user.id
    render :partial => 'todolist', :collection => todo
  end
  
  def home_load_trackings    
    render :partial => "home_tab_trackings", :locals => {:pending_trackings => @user.pending_trackings, :user_trackings => User.home_more_trackings(0, @user.id)}
  end
  
  def home_more_trackings
    todo = User.home_more_trackings params[:page_num], @user.id
    render :partial => 'todolist', :collection => todo
  end
  
  def profile_load_log_timeline
    #share the same partial with home_load_log_timeline, separate when necessary
    render :partial => "home_log_timeline", :locals => {:site_logs => User.find(decode(params[:id])).site_logs }
  end
  
  def profile_load_lists
    render :partial => "profile_tab_lists", :locals => {:lists => User.profile_more_lists(0, decode(params[:id]))}
  end
  
  def profile_more_lists
    id = decode params[:id]
    todo = User.profile_more_lists params[:page_num], id, session[:user_id]
    render :partial => 'todolistProfile', :collection => todo
  end
  
  def profile_load_trackings
    render :partial => "profile_tab_trackings", :locals => {:user_trackings => User.profile_more_trackings(0, decode(params[:id]), session[:user_id]) }
  end
  
  def profile_more_trackings
    id = decode params[:id]
    todo = User.profile_more_trackings params[:page_num], id, session[:user_id]
    render :partial => 'todolistProfile', :collection => todo
  end
  
#  def home_load_contacts
#    gid = decode params[:id]
#    
#    if gid.blank?
#      render :partial => "home_contacts", :collection => @contacts
#    else
#      render :partial => "home_contacts", :collection => ContactGroup.find(gid).contacts
#    end
#    
#  end
  def upload_avatar
    image = Image.find(:first, :conditions=>["user_id = ?", session[:user_id]])
    if !image.blank?
      image.destroy()
    end
    image = Image.new(params[:image])
    image.user_id = session[:user_id]
    image.image_type = 0
    image.save()
    if image.save()
      render :partial => 'image', :object => image
    else
      data = {}
      data[:error] = image.errors
      render :text => data.to_json
      return
    end
  end

  def chop_avatar
    @user = User.find(session[:user_id])
    avatar_raw = @user.avatar_path('raw')
    img = Magick::Image.read(avatar_raw)[0]
    img = img.scale!((img.columns*params[:scale].to_f/50.0).ceil,(img.rows*params[:scale].to_f/50.0).ceil).crop(params[:left].to_i, params[:top].to_i, 128, 128)
    img.write(@user.avatar_path('large'))
    img.resize_to_fill(52, 52).write(@user.avatar_path('medium'))
    img.resize_to_fill(20, 20).write(@user.avatar_path('small'))
    render :text => @user.avatar_url('large')
  end
end
