# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
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
      when second..minute
        output = (t/second).to_i.to_s + " seconds"
      when minute..hour
        output = (t/minute).to_i.to_s + " minutes"
      when hour..day
        output = (t/hour).to_i.to_s + " hours"
      when day..week
        output = (t/day).to_i.to_s + " days"
      when week..month
        output = (t/week).to_i.to_s + " weeks"
      when month..year
        output = (t/month).to_i.to_s + " months"
      when year..year*10
        output = (t/year).to_i.to_s + " years"
      else
        return " just now"
    end
    return output.gsub(/^(1\s[a-zA-Z]+)s/,'\1') + " ago"
  end
  
  def log_for(t)
    log_type = Hash[
      "sign_in" => "signed in",
      "sign_out" => "signed out",
      "start_tracking" => "started a tracking",
      "stop_tracking" => "stopped a tracking",
      "new_list" => "created a new list",
      "new_list_saved_fr" => "created a new list saved from",
      "delete_list" => "deleted a list",
      "update_list" => "updated a list",
      "update_profile" => "updated profile",
      "accept_tracking" => "accepted a tracking",
      "ignore_tracking" => "ignored a tracking"
    ]
    return log_type[t]
  end
  
  def encode param
    Base64.encode64(Base64.encode64(param.to_s)).chomp
  end
  
  def decode(param)
    Base64.decode64(Base64.decode64(param.to_s)).chomp
  end
  
end
