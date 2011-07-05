require 'faker'

namespace :db do
  desc "Fill Database With Sample Data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Client.create!(
      :first_name => "Jimmy",
      :last_name => "Jimmerson",
      :phone => 4224954399,
      :email => "jj@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    )
    25.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      phone = Faker::PhoneNumber.phone_number
      email = "jimmy-#{n+1}@example.com"
      password = "foobar"
      Client.create!(
        :first_name => first_name,
        :last_name => last_name,
        :phone => phone,
        :email => email,
        :password => password,
        :password_confirmation => password
      )
    end
    
    Client.all.each do |client|
      street = Faker::Address.street_address
      city = Faker::Address.city
      state = Faker::Address.us_state_abbr
      zip = Faker::Address.zip_code
      client.client_addrs.create!(
        :street => street,
        :city => city,
        :state => state,
        :zip => zip,
        :title => "Primary"
      )
    end
    
    index = 0
    Client.all.each do |client|
      index += 1
      qtitle = client.first_name + "-" + index.to_s
      quote = client.quotes.create!(
        :qtitle => qtitle
      )
      item_num = "ksx-" + quote.id.to_s
      desc = Faker::Address.city
      qty = 2
      price = 22.99
      notes = "Requires dirt."
      quote_item = quote.quote_items.create!(
        :item_num => item_num,
        :desc => desc,
        :qty => qty,
        :price => price,
        :notes => notes
      )
    end
    
  end
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