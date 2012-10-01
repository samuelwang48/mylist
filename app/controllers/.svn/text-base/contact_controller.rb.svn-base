class ContactController < ApplicationController
  layout "master", :except => []
  before_filter :authentication
  
  verify :method => :post, :only => [:add_local, :update, :create, :delete, :bulk_delete, :bulk_grouping, :rename_group, :delete_group, :send_invitation], :redirect_to => '/web/home'
  before_filter :caching_objects
  before_filter :auth_contact_ownership, :only => [:update, :edit, :delete, :bulk_delete, :bulk_grouping, :invite]
  before_filter :auth_contact_group_ownership, :only => [:update, :create, :bulk_grouping, :rename_group, :delete_group]
  
  private
  def caching_objects
    @contacts = get_cached('@contacts', 'User.find(id).contacts')
    @user_contact_groups = get_cached('@user_contact_groups', 'User.find(id).contact_groups')
    @html_contactsPicker = get_cached('@html_contactsPicker', 'render_to_string :partial => "layouts/contactsPicker"')
    @html_contactsNav = get_cached('@html_contactsNav', 'render_to_string :partial => "contactsNav"')
    @html_contact_items = get_cached('@html_contact_items', "render_to_string :partial => 'contactItem', :collection => @contacts")
  end
  
  def flush_cached_objects
    flush_cached('@contacts')
    flush_cached('@user_contact_groups')
    flush_cached('@html_contactsPicker')
    flush_cached('@html_contactsNav')
    flush_cached('@html_contact_items')
    
    caching_objects()
  end
  
  def auth_contact_ownership
    if !params[:id].nil?
      @error = []
      @contact_id_a = ActiveSupport::JSON.decode(params[:id]).to_a
      
      @contacts = Contact.find(@contact_id_a.collect{|i|decode(i)})
      @contacts.each{|c|
        contact_owner = c.user
        auth = @user.id.to_s == contact_owner.id.to_s
        if !auth
          @error.push('You are not owner of the contact. Thanks')
          break
        end
      }
      
      @contact = @contacts[0]
    else
      @contacts = []
      @contact = nil
    end
  end
    
  def auth_contact_group_ownership
    @error = []
    specified_contact_groups = params[:contact_groups].nil? ? [] : ActiveSupport::JSON.decode(params[:contact_groups]).to_a
    @specified_contact_groups = ContactGroup.find(specified_contact_groups)
    @specified_contact_groups.each{|g|
      contact_owner = g.user
      auth = @user.id.to_s == contact_owner.id.to_s
      if !auth
        @error.push('You are not owner of the contact group. Thanks')
        break
      end
    }
    
  end
  
  public
  def send_invitation
    invited_contacts = ActiveSupport::JSON.decode(params[:invited_contacts])
    @error = []
    contact_id_a = invited_contacts.collect{|c|decode(c['id'])}
    @contacts = Contact.find(contact_id_a)
    @contacts.each{|c|
      contact_owner = c.user
      auth = session[:user_id].to_s == contact_owner.id.to_s
      if !auth
        @error.push('You are not owner of the contact. Thanks')
        break
      end
    }
    
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      data = {}
      data[:email_error] = 0
      
      if ITODO_INVITE_LIMIT-@user.invitations.size <= 0
        data[:email_error] = 'You have reached the invitation limit.'
        render :text => data.to_json, :layout => false
        return
      end
      
      contact_emails = invited_contacts.collect{|c|c['email']}
      contact_emails.each{|e|
        if (e =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i) == nil
          data[:email_error] = 'Oops, some of the addresses you entered look invalid. Double check the addresses and try again.'
        end
      }
      invited_emails = params[:invited_emails].gsub(/\s/, '').split(',')
      invited_emails.each{|e|
        if (e =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i) == nil
          data[:email_error] = 'Oops, some of the addresses you entered look invalid. Double check the addresses and try again.'
        end
      }
      
      if data[:email_error] == 0
        invited_contacts.each{|c|
          r = User.find(:all, :conditions=>["email = ?", c['email']])
          if r.size > 0
            #pp 'already a user, send a contact request, deduct one invitation'
            subject = 'New contact request from itodo.it'
            m = "To get connected, \n"
            m = m + 'visit '+server_host+'/invite/'
            
            invitation_type = 0
          else
            #pp 'not a user, send an invitation, deduct one invitation'
            subject = 'You have been invited to join itodo.it'
            m = "You are invited to open a free itodo.it account. To accept this invitation and create your account, \n"
            m = m + 'visit '+server_host+'/invite/'
            
            invitation_type = 1
          end
          
          inv = Invitation.new()
          inv.user_id = @user.id
          inv.contact_id = decode(c['id'])
          inv.invitation_type = invitation_type
          inv.status = 1
          
          md5 = Digest::MD5.hexdigest((Invitation.last ? Invitation.last.id+1 : 1).to_s+'inv')
          len = md5.size
          token = md5.insert(((len/4)*3).to_i, '-').insert(((len/4)*2).to_i, '-').insert(((len/4)*1).to_i, '-')
          token = token.split('-')
          token = ['a','b','c','d','e','f'][rand(6).to_i]+'-'+token[3]+'-'+token[1]+'-'+token[0]+'-'+token[2]
          inv.token = token
          inv.save()
          
          #emails are not sent
          send_email([c['email']], subject, m+token)
        }
        
        invited_emails.each{|e|
          r = User.find(:all, :conditions=>["email = ?", e])
          if r.size > 0
            #pp 'already a user, send a contact request, deduct one invitation'
            subject = 'New contact request from itodo.it'
            m = "To get connected, \n"
            m = m + 'visit '+server_host+'/invite/'
            
            invitation_type = 0
          else
            #pp 'not a user, send an invitation, deduct one invitation'
            subject = 'You have been invited to join itodo.it'
            m = "You are invited to open a free itodo.it account. To accept this invitation and create your account, \n"
            m = m + 'visit '+server_host+'/invite/'
            
            invitation_type = 1
          end
          
          contact = Contact.new()
          contact.user_id = @user.id
          contact.local_user_id = 0
          contact.firstname = ''
          contact.lastname = ''
          contact.save()
          
          field = ContactField.new()
          field.contact_id = contact.id
          field.name = 'Email'
          field.value = e
          field.ftype = ITODO_CONTACT_FIELD_TYPES['Email']
          field.save()
          
          inv = Invitation.new()
          inv.user_id = @user.id
          inv.contact_id = contact.id
          inv.invitation_type = invitation_type
          inv.status = 1
          
          md5 = Digest::MD5.hexdigest((Invitation.last ? Invitation.last.id+1 : 1).to_s+'inv')
          len = md5.size
          token = md5.insert(((len/4)*3).to_i, '-').insert(((len/4)*2).to_i, '-').insert(((len/4)*1).to_i, '-')
          token = token.split('-')
          token = ['a','b','c','d','e','f'][rand(6).to_i]+'-'+token[3]+'-'+token[1]+'-'+token[0]+'-'+token[2]
          inv.token = token
          inv.save()
          
          
          send_email([e], subject, m+token)
        }
        
      end
      
      render :text => data.to_json, :layout => false
    end
  end
  
  def invite
    @invite_limit = ITODO_INVITE_LIMIT
  end
  
  def rename_group
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      @specified_contact_groups.each{|g|
        ContactGroup.update(g.id, { :name => params[:name] })
      }
      
      flush_cached_objects()
      render :text => ''.to_json, :layout => false
    end
    
  end
  
  def delete_group
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      @specified_contact_groups.each{|g|
        ContactGroup.find(g.id).destroy
      }
      
      flush_cached_objects()
      render :text => ''.to_json, :layout => false
    end
    
  end
  
  def bulk_delete
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      
      contacts_id = @contact_id_a.collect{|i|decode(i)}
      Contact.destroy(contacts_id)
      group_counts = @user.contact_groups.collect{|g|g.contacts.size}
      group_counts.insert(0,@user.contacts.size)

      data = {:contacts_id => contacts_id, :group_counts => group_counts}
      
      flush_cached_objects()
      render :text => data.to_json, :layout => false
    end
  end
  
  def bulk_grouping
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      
      
      @specified_contact_groups.each{|g|
        group_contacts_id = g.contacts.collect{|c|c.id}
        @contacts.each{|c|
          if group_contacts_id.include?(c.id)
            
          else
            rel = ContactGroupsRelation.new()
            rel.contact_id = c.id
            rel.contact_group_id = g.id
            rel.save()
          end
        }
      }
      
      group_counts = @user.contact_groups.collect{|g|g.contacts.size}
      group_counts.insert(0,@user.contacts.size)
      
      contacts_id = @contacts.collect{|i|i.id}
      data = {:contacts_id => contacts_id, :group_counts => group_counts, :group_name => @specified_contact_groups[0].name }
      
      
      flush_cached_objects()
      render :text => data.to_json, :layout => false
    end
  end
  
  def delete
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      @contact.destroy()
      flush_cached_objects()

      render :text => 'delete success', :layout => false
    end
  end
  
  def testca
    
    @contacts = get_cached('@user_contacts', 'User.find(id).contacts')
    @user_contact_groups = get_cached('@user_contact_groups', 'User.find(id).contact_groups')
    @html_contact_items = get_cached('@html_contact_items', "render_to_string :partial => 'contactItem', :collection => @contacts")
    @html_contactsNav = get_cached('@html_contactsNav', 'render_to_string :partial => "contactsNav"')
    
    render :text => @html_contactsNav, :layout => false
  end
  
  def home    
    group_id = params[:id] ? decode(params[:id]) : nil
    
    
    if group_id.blank?
      
    else
      @current_group = ContactGroup.find(group_id)
      @current_contacts = @current_group.contacts
      @html_current_contact_items = render_to_string :partial => 'contactItem', :collection => @current_contacts
    end
  end
  
  def add_local
    
    
    contact_user_id = params[:user_id]
    if contact_user_id
      contact = User.find(contact_user_id)
      contact['anniversary'] = nil
      contact['url'] = nil
      contact['local_user_id'] = contact_user_id.to_i
      #!!!important which is not implemented
      #if in user privacy settings he chooses not to appear in people search result, then error should be thrown here
      
      #if in user privacy settings he choose to appear, while his profile is invisible to me, 
      #then his contact information should not be loaded
      
      #only if he wants to appear in search result AND his profile is visible to me,
      #then his contact info will be loaded except phone number
    end
    @contact = contact
    
    render :action => "add"
  end
  
  def update
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      
      
      firstname = params[:firstname]
      lastname = params[:lastname]
      
      contact = {}
      contact['firstname'] = firstname
      contact['lastname'] = lastname
      
      @contact.update_attributes(contact)
      
  
      specified_contact_groups = params[:contact_groups].nil? ? [] : ActiveSupport::JSON.decode(params[:contact_groups])
      user_contact_groups = @user.contact_groups
      
      user_contact_groups.each {|g|
        #puts specified_contact_groups.include?(g.id.to_s).to_s + '______' + g.id.to_s
        relation = ContactGroupsRelation.find(:first, :conditions => [ "contact_id = ? and contact_group_id = ?", @contact.id, g.id])
   
        if specified_contact_groups.include?(g.id.to_s)
          #create if not exists
          if relation
            #yes, leave it
          else
            #no, create new
            rel = ContactGroupsRelation.new()
            rel.contact_id = @contact.id
            rel.contact_group_id = g.id
            rel.save()
          end
        else
          #destroy if exists
          if relation
            #yes, destroy it
            relation.destroy()
          else
            #no, leave it
          end
        end
      }
      
      contact_fields = ActiveSupport::JSON.decode(params[:contact_fields])
      
      existing_fields_id = @contact.contact_fields.collect{|i|i.id.to_s}
      
      contact_fields.each {|f|
        if existing_fields_id.include?(f['id'].to_s)
          #if contact field exists, then update
          if !f['field_value'].nil? && f['field_value'].gsub(/^\s+/,'').gsub(/\s+$/,'') == ''
            field = ContactField.find(f['id'])
            field.destroy()
          else
            field = ContactField.find(f['id'])
            field.name = f['field_name']
            field.value = f['field_value']
            field.save()
          end
          existing_fields_id.delete(f['id'].to_s)
        else
          if !f['field_value'].nil? && f['field_value'].gsub(/^\s+/,'').gsub(/\s+$/,'') == ''
            
          else
            field = ContactField.new()
            field.contact_id = @contact.id
            field.name = f['field_name']
            field.value = f['field_value']
            field.ftype = ITODO_CONTACT_FIELD_TYPES[f['type']]
            field.save()
          end
        end
      }
      
      existing_fields_id.each{|id|
        field = ContactField.find(id)
        field.destroy()
      }
      
      flush_cached_objects()
      render :text => {:id => encode(@contact.id)}.to_json, :layout => false
    end
  end
  
  def add
    
    contact = User.new()
    contact['anniversary'] = nil
    contact['url'] = nil
    contact['local_user_id'] = nil
    @contact = contact
  end
  
  def create
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
    
      
      q = params[:local_user_id]
      
      firstname = params[:firstname]
      lastname = params[:lastname]
      
      r = User.find(:first, :conditions => [ "id = ? AND searchable = 1", q])
      
      local = r ? r.id : 0
      
      contact = Contact.new()
      contact.user_id = @user.id
      contact.local_user_id = local
      contact.firstname = firstname
      contact.lastname = lastname
      contact.save()
      
      specified_contact_groups = params[:contact_groups].nil? ? [] : ActiveSupport::JSON.decode(params[:contact_groups])
      user_contact_groups = @user.contact_groups
      
      user_contact_groups.each {|g|
        #puts specified_contact_groups.include?(g.id.to_s).to_s + '______' + g.id.to_s
        if specified_contact_groups.include?(g.id.to_s)
          rel = ContactGroupsRelation.new()
          rel.contact_id = contact.id
          rel.contact_group_id = g.id
          rel.save()
        else
          
        end
      }
      
      contact_fields = ActiveSupport::JSON.decode(params[:contact_fields])
      contact_fields.each {|f|
        if f['field_value'].gsub(/^\s+/,'').gsub(/\s+$/,'') == ''
          
        else
          field = ContactField.new()
          field.contact_id = contact.id
          field.name = f['field_name']
          field.value = f['field_value']
          field.ftype = ITODO_CONTACT_FIELD_TYPES[f['type']]
          field.save()
        end
      }
      
      flush_cached_objects()
      
      render :text => {:id => encode(contact.id)}.to_json, :layout => false
    end
  end
  
  def edit
    if @error.size > 0
      render :text => @error.join('<br>'), :layout => false
    else
      
    end
  end
  
  def new_group
    group_name = params[:groupname]
    
    group = ContactGroup.new()
    group.user_id = session[:user_id]
    group.name = group_name
    
    flush_cached('@user_contact_groups')
    flush_cached('@html_contactsPicker')
    flush_cached('@html_contactsNav')
    
    if group.save
      render :text => group.to_json, :layout => false
    else
      render :text => '', :layout => false
    end
    
    
  end
  
end
