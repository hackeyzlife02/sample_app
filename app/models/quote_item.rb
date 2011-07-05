class QuoteItem < ActiveRecord::Base
  attr_accessible :item_num, :desc, :qty, :price, :notes
  
  belongs_to :quote
  
  default_scope :order => 'quote_items.quote_id ASC'
    
  validates :item_num,  :presence => true,
                          :length => { :maximum => 45 }
  
  validates :desc,  :presence => true,
                      :length => { :maximum => 45 }
                      
  validates :qty,  :presence => true,
                    :length => { :maximum => 6 }

  validates :price,  :presence => true,
                      :length => { :maximum => 8 }
  
  validates_numericality_of :price
  
  validates :notes,  :presence => true,
                      :length => { :maximum => 45 }
                      
  validates :quote_id, :presence => true
  
  def total
    qty * price
  end
end


# == Schema Information
#
# Table name: quote_items
#
#  id         :integer         not null, primary key
#  item_num   :string(255)
#  desc       :string(255), maximum => 45
#  qty        :integer, maximum => 6
#  price      :decimal(8, 2), maximum => 8
#  notes      :string(255), maximum => 45
#  quote_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

