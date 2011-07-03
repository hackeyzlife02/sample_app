class AddTitleToClientAddrs < ActiveRecord::Migration
  def self.up
    add_column :client_addrs, :title, :string
  end

  def self.down
    remove_column :client_addrs, :title
  end
end
