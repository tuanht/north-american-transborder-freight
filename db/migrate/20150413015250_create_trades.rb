class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :trade_type, null: false
      t.integer :country_id, null: false
      t.integer :usa_state_id
      t.integer :port_id
      t.integer :mode_id, null: false
      t.integer :state_id
      t.integer :commodity_id
      t.decimal :value,             precision: 13, scale: 2, default: 0.0
      t.decimal :shipwt,            precision: 13, scale: 2, default: 0.0
      t.decimal :freight_charges,   precision: 13, scale: 2, default: 0.0
      t.integer :df
      t.boolean :containerized
      t.date :date
      t.integer :table_type
      t.timestamps null: false
    end
  end
end
