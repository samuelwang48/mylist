class ReminderController < ApplicationController
  before_filter :authentication
  
  def update
    reminder_id = params[:reminder_id]
    reminder = {}
    reminder['user_id'] = session[:user_id]
    reminder['todo_id'] = params[:todo_id]
    reminder['item_id'] = params[:item_id]
    reminder['event'] = params[:event]
    reminder['method_phone_def'] = params[:method_phone_def]
    reminder['method_email_def'] = params[:method_email_def]
    reminder['method_email_alt'] = params[:method_email_alt]
    reminder['occurence'] = params[:occurence]
    reminder['seconds_before'] = params[:seconds_before]
    
    #SMS sending sample
    if reminder['method_phone_def'] == 'true'
      send_sms([@user.phone_mobile], reminder['event'])
    end

    #mail sending sample
    if reminder['method_email_def'] == 'true'
      @email = @user.email
    elsif reminder['method_email_alt'] == 'true'
      @email = @user.email_alt
    else
      @email = false
    end

    if @email != false
      send_email([@email], 'New Reminder from itodo.it', reminder['event'])
    end
    
    if reminder_id
      @reminder = Reminder.find(reminder_id)
      @reminder.update_attributes(reminder)
      render :text => @reminder.to_json, :layout => false
    else
      @reminder = Reminder.new(reminder)
      if @reminder.save
        render :text => @reminder.to_json, :layout => false
      else
        render :text => '', :layout => false
      end
    end
  end
  
  
  
end
