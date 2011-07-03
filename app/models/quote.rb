class Quote < ActiveRecord::Base
  attr_accessible :qtitle
  
  belongs_to :client
  
  has_many :quote_item
  
  default_scope :order => 'quotes.updated_at DESC'
  
  validates :qtitle,  :presence => true,
                      :length => { :maximum => 45 }
                      
  validates :client_id, :presence => true
end

# == Schema Information
#
# Table name: quotes
#
#  id         :integer         not null, primary key
#  qtitle     :string(255)
#  client_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

