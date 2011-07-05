Factory.define :client do |client|
  client.first_name             "Jimmy"
  client.last_name              "Smiles"
  client.email                  "jimmysmiles@example.com"
  client.phone                  "0123456789"
  client.password               "foobar"
  client.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :client_addr do |client_addr|
  client_addr.title "Primary"
  client_addr.street "Street"
  client_addr.city "City"
  client_addr.state "State"
  client_addr.zip 12345
  client_addr.association :client
end

Factory.define :quote do |quote|
  quote.qtitle "Incline"
  quote.association :client
end

Factory.sequence :qtitle do |n|
  "Incline #{n}"
end

Factory.define :quote_item do |quote_item|
  quote_item.item_num "K23-B"
  quote_item.desc "Rocks"
  quote_item.qty 2
  quote_item.price 24.99
  quote_item.notes "Requires some dirt"
  quote_item.association :quote
end

Factory.sequence :item_num do |n|
  "KBQ-#{n}"
end