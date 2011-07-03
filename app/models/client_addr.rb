class ClientAddr < ActiveRecord::Base
  attr_accessible :title, :street, :city, :state, :zip
  
  belongs_to :client
  
  default_scope :order => 'client_addrs.created_at ASC'
  
  validates :title,  :presence => true,
                      :length => { :maximum => 45 }
  
  validates :street,  :presence => true,
                      :length => { :maximum => 140 }
  
  validates :city,  :presence => true,
                    :length => { :maximum => 140 }
  
  validates :state, :presence => true,
                    :length => { :maximum => 140 }
  
  validates :zip,   :presence => true,
                    :length => { :maximum => 5 }
        
  validates :client_id, :presence => true
end






# == Schema Information
#
# Table name: client_addrs
#
#  id         :integer         not null, primary key
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :integer
#  client_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#

