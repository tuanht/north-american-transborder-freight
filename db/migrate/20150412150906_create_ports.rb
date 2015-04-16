class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.string :code, null: false, limit: 4
      t.string :name
      t.integer :port_type
    end
    add_index :ports, :code, unique: true
  end
end
