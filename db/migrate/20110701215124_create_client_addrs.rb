class CreateClientAddrs < ActiveRecord::Migration
  def self.up
    create_table :client_addrs do |t|
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :client_id

      t.timestamps
    end
    add_index :client_addrs, :client_id
  end

  def self.down
    drop_table :client_addrs
  end
end
