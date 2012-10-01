class AddRememberMeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:remember_me,:string, :default => nil
    
    User.find(:all).each_with_index do |u, i|
      u.remember_me = Digest::MD5.hexdigest((i+1).to_s + Time.now().to_i.to_s)
      u.save()
    end
  end

  def self.down
    remove_column :users,:remember_me
  end
end
