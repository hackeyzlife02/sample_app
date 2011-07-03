class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string :qtitle
      t.integer :client_id

      t.timestamps
    end
    add_index :quotes, :client_id
    add_index :quotes, :updated_at
  end

  def self.down
    drop_table :quotes
  end
end
