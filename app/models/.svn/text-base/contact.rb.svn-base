class Contact < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  has_many :contact_fields, :dependent => :destroy
  has_many :contact_groups_relations, :dependent => :destroy
  has_many :contact_groups,:through=>:contact_groups_relations
  has_many :todo_permissions, :dependent => :destroy
  has_one :invitation
  
  def local
    User.find(local_user_id)
  end
  
#  def self.contacts_for_group gid
#    #Contact.find_by_sql(["select * from contacts as c inner join contact_groups_relations as r on (c.id=r.contact_id) where contact_group_id=?;", gid])
#    #Contact.find(ContactGroupsRelation.find(:all, :conditions=>["contact_group_id = ?", gid]).collect{|r|r.contact_id})
#    ContactGroup.find(gid).contacts
#  end
  
  def fields_for type
    r = ContactField.find(:all, :conditions=>["contact_id = ? and ftype = ?", id, ITODO_CONTACT_FIELD_TYPES[type]])
  end
  
end
