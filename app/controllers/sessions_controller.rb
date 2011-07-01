class SessionsController < ApplicationController
  
  def new
    @title = "Sign in"
  end
  
  def create
    client = Client.authenticate( params[:session][:email],
                                  params[:session][:password] )
                                  
    if client.nil?
      flash.now[:error] = "Invalid email/password combination"
      @title = "Sign in"
      render 'new'
    else
      
    end
  end
  
  def destroy
  end

end
