class Client < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :first_name, :last_name, :phone, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :first_name,  :presence => true,
                          :length => { :maximum => 50 }
  validates :last_name,   :presence => true,
                          :length => { :maximum => 50 }
  validates :phone,       :presence => true
  validates :email,       :presence => true,
                          :format => { :with => email_regex },
                          :uniqueness => { :case_sensitive => false }
  validates :password,    :presence => true,
                          :confirmation => true,
                          :length => {:within => 6..40 }
                      
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  class << self
    def authenticate(email,submitted_password)
      client = find_by_email(email)
      return nil      if client.nil?
      return client   if client.has_password?(submitted_password)
    end
  end
  
  private 
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
  
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

# == Schema Information
#
# Table name: clients
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  phone              :integer
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

