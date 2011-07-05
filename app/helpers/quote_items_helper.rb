module QuoteItemsHelper
  
  def itemtotal(qty, price)
    number_to_currency(qty*price)
  end
  
end
