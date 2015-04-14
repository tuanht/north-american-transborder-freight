class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :country_id, null: false
      t.string :code, limit: 2
      t.string :name
    end
  end
end
