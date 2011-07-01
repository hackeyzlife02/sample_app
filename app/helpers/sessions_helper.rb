module SessionsHelper
  
  def sign_in(client)
    cookies.permanent.signed[:track_token] = [client.id, client.salt]
    self.current_client = client
  end
  
  def current_client=(client)
    @current_client = client
  end
  
  def current_client
    @current_client ||= client_from_track_token
  end
  
  def signed_in?
    !current_client.nil?
  end
  
  def sign_out
    cookies.delete(:track_token)
    self.current_client = nil
  end
  
  private

      def client_from_track_token
        Client.authenticate_with_salt(*track_token)
      end

      def track_token
        cookies.signed[:track_token] || [nil, nil]
      end
      
  
end

