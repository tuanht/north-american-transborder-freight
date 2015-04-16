class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :trade_type, null: false
      t.belongs_to :country, null: false
      t.belongs_to :usa_state
      t.belongs_to :port
      t.belongs_to :mode, null: false
      t.belongs_to :state
      t.belongs_to :commodity
      t.decimal :value,             precision: 13, scale: 2, default: 0.0
      t.decimal :shipwt,            precision: 13, scale: 2, default: 0.0
      t.decimal :freight_charges,   precision: 13, scale: 2, default: 0.0
      t.integer :df
      t.boolean :containerized
      t.date :date
      t.integer :table_type
      t.timestamps null: false
    end

    add_index :trades, :table_type
    add_index :trades, :trade_type
  end
end
