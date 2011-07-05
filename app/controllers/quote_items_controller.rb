class QuoteItemsController < ApplicationController
  before_filter :authenticate
  
  def new
  end
  
  def create
    @quote = Quote.find(params[:quote_id])
    @quote_item  = @quote.quote_items.build(params[:quote_item])
    if @quote_item.save
      @quote_items = @quote.quote_items.paginate(:page => params[:page], :per_page => 10)
      flash[:success] = "#{@quote_item.item_num} successfully added."
      redirect_to edit_quote_path(@quote.id)
    else
      flash[:error] = "Unable to add #{@quote_item.item_num}."
      redirect_to edit_quote_path(@quote.id)
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def destroy
  end
  
  def update
    @quote_item = QuoteItem.find(params[:id])
    @quote = @quote_item.quote
    @quote_item.destroy
    render edit_quote_path(@quote.id)
  end
  
  def itemtotal(qty, price)
    number_to_currency(qty*price)
  end
end
