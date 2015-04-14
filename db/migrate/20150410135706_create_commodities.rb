class CreateCommodities < ActiveRecord::Migration
  def change
    create_table :commodities do |t|
      t.string :code, null: false, limit: 2
      t.text :description
    end
    add_index :commodities, :code, unique: true
  end
end
