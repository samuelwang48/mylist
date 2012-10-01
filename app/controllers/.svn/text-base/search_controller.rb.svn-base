class SearchController < ApplicationController
  layout "master", :except => [:peopleByEmail]
  before_filter :authentication
  
  def people
    
  end
  
  def peopleByEmail
    q = params[:queryString]
    r = User.find(:first, :conditions => [ "email = ? AND searchable = 1", q])
    
    if r
      if r.username.nil? || r.username == ''
        dat = '/profile/'+encode(r.id)
      else
        dat = '/profile/'+r.username
      end
      render :text => dat, :layout => false
    else
      render :text => r.to_json, :layout => false
    end
    
    
  end
  
  
end
