class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.belongs_to :country, null: false
      t.string :code, limit: 2
      t.string :name
    end
    add_index :states, :code
  end
end
