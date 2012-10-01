class GeneratePermissionsForMycontacts < ActiveRecord::Migration
  def self.up
    Todo.find(:all).each do |todo|
      permission = TodoPermission.new()
      permission.todo_id = todo.id
      permission.contact_id = -1
      permission.r = 1
      permission.w = 0
      permission.d = 0
      permission.save()
      
      permission = TodoPermission.new()
      permission.todo_id = todo.id
      permission.contact_id = -2
      permission.r = 1
      permission.w = 0
      permission.d = 0
      permission.save()
    end
  end

  def self.down
  end
end
