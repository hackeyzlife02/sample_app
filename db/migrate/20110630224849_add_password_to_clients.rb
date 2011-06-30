class AddPasswordToClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :encrypted_password, :string
  end

  def self.down
    remove_column :clients, :encrypted_password
  end
end
