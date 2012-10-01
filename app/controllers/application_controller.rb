# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  Contact
  ContactGroup

  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :text => 'RNF Please do not try to hack us'
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def authentication
    unless session[:user_id].nil?
      get_user_info
    else
      if !cookies[:RL].blank?
        u = User.find(:first, :conditions=>["remember_me = ?", cookies[:RL]])
        if !u.blank?
          session[:user_id] = u.id
          get_user_info
        else
          redirect_to '/web/login'
        end
      else
        redirect_to '/web/login'
      end
    end
  end
  
  def get_user_info
    @session_user = @user = get_cached('@user', 'User.find(id)')
    @contacts = get_cached('@contacts', 'User.find(id).contacts')
    @user_contact_groups = get_cached('@user_contact_groups', 'User.find(id).contact_groups')
    @html_contactsPicker = get_cached('@html_contactsPicker', 'render_to_string :partial => "layouts/contactsPicker"')
    @html_reminderFormTpl = get_cached('@html_reminderFormTpl', 'render_to_string :partial => "layouts/reminderFormTpl"')
  end
  
  def flush_cached(key)
    id = session[:user_id].to_s
    key = key + '_'
    #CACHE.delete(key + id)
  end

  def get_cached(key, val)
    id = session[:user_id].to_s
    key = key + '_'
#    if CACHE.get(key + id).nil?
#      val = eval(val)
#      CACHE.add(key + id, val, 3600)
#      CACHE.get(key + id)
#    else
#      CACHE.get(key + id)
#    end
    eval(val)
  end

  def get_auth(todo)
    
    user_auth = {}
    
    if @user.id == todo.user_id
      pp 'is owner'
      user_auth['r'] = true
      user_auth['w'] = true
      user_auth['d'] = true
    else
      pp 'not owner'
      p = todo.permission_contact(@user.id)
      pp p.size
      if todo.permission_public['r'] == true
        user_auth['r'] = true
      elsif todo.permission_mycontacts['r'] == true && todo.user.contacts.collect{|i|i.local_user_id}.include?(@user.id)
        user_auth['r'] = true
      elsif p.size > 0
        user_auth['r'] = p[0]['r']
      else
        user_auth['r'] = false
      end
      
      if todo.permission_public['w'] == true
        user_auth['w'] = true
      elsif todo.permission_mycontacts['w'] == true
        user_auth['w'] = true
      elsif p.size > 0
        user_auth['w'] = p[0]['w']
      else
        user_auth['w'] = false
      end
      
      if todo.permission_public['d'] == true
        user_auth['d'] = true
      elsif todo.permission_mycontacts['d'] == true
        user_auth['d'] = true
      elsif p.size > 0
        user_auth['d'] = p[0]['d']
      else
        user_auth['d'] = false
      end
    end
    

    
    return user_auth
  end

  
  def to_pretty(t)
    t = Time.now - t
    second = 1;
    minute = second*60;
    hour = minute*60;
    day = hour*24;
    week = day*7;
    month = week*4;
    year = month*12;
   
    case t
      when 0
        output = "now"
      when second..minute
        output = (t/second).to_i.to_s + " second"
      when minute..hour
        output = (t/minute).to_i.to_s + " minute"
      when hour..day
        output = (t/hour).to_i.to_s + " hour"
      when day..week
        output = (t/day).to_i.to_s + " day"
      when week..month
        output = (t/week).to_i.to_s + " week"
      when month..year
        output = (t/month).to_i.to_s + " month"
      when year..year*10
        output = (t/year).to_i.to_s + " year"
      else
        return " just now"
    end
    return output + " ago"
  end

  def encode param
    return Base64.b64encode(Base64.b64encode(param.to_s)).chomp
  end

  def decode(param)
    return Base64.decode64(Base64.decode64(param.to_s)).chomp
  end
  
  def send_sms(mobs, textbody)
    begin
      mobs = mobs.join(',')
      uri = URI.parse(ITODO_SMS_SERVICE)
      res = Net::HTTP.post_form(uri, {'mobNo'=>mobs, 'content'=>textbody.utf8_to_gb, 'token'=>'a386b09897886c02988e1f04fbe95e8f'})
    rescue
    
    end
  end
  
  def send_email(email, subject, mailbody)
    greeting = ""
    signature = "\n\n\nThanks,\nitodo.it"
    count = 0
    
    begin
      Net::SMTP.start(ITODO_MAIL_SERVICE, ITODO_MAIL_SERVICE_PORT) do |smtp|
        smtp.open_message_stream('noreply@itodo.it', email) do |f|
          f.puts 'From: itodo.it <noreply@itodo.it>'
          f.puts 'To: ' + email[count]
          f.puts 'Subject: ' + subject
          f.puts
          f.puts greeting + mailbody + signature
          count = count + 1
        end
      end
    rescue
    
    end
  end
  
  def server_host
    if request.port == 80
      'http://itodo.it'
    else
      'http://itodo.it:'+request.port.to_s
    end
  end
end


class String
  def utf8_to_gb
    Iconv.conv("gb2312//IGNORE","UTF-8//IGNORE",self)
  end
  
  def gb_to_utf8
    Iconv.conv("UTF-8//IGNORE","GB18030//IGNORE",self)
  end
end