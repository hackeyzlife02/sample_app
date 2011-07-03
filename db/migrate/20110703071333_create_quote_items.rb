class CreateQuoteItems < ActiveRecord::Migration
  def self.up
    create_table :quote_items do |t|
      t.string :item_num
      t.string :desc
      t.integer :qty
      t.decimal :price, :precision => 8, :scale => 2
      t.string :notes
      t.integer :quote_id

      t.timestamps
    end
    add_index :quote_items, :quote_id
  end

  def self.down
    drop_table :quote_items
  end
end
