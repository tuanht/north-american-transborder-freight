class CreateUsaStates < ActiveRecord::Migration
  def change
    create_table :usa_states do |t|
      t.string :code, null: false, limit: 2
      t.string :name
    end
    add_index :usa_states, :code, unique: true
  end
end
