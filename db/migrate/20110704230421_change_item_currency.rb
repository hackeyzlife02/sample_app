class ChangeItemCurrency < ActiveRecord::Migration
  
  def ChangeItemCurrency::fixDollarsToCents(model, fields)
        records = model.find(:all)
        records.each do |rec|
            fields.each do |field|
                d = rec.send(field)
                d = d * 100
                rec.update_attribute(field,d)
            end
        end
    end
  
  def self.up
    
    fixDollarsToCents(QuoteItem, [:price])
    
    change_column(:quote_items, :price, :integer)

    rename_column(:quote_items, :price, :price_in_cents)

  end

  def self.down
  end
end
