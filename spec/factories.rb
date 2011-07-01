Factory.define :client do |client|
  client.first_name             "Jimmy"
  client.last_name              "Smiles"
  client.email                  "jimmysmiles@example.com"
  client.phone                  "0123456789"
  client.password               "foobar"
  client.password_confirmation  "foobar"
end