class ContactGroup < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  has_many :contact_groups_relations, :dependent => :destroy
  has_many :contacts,:through=>:contact_groups_relations
end
