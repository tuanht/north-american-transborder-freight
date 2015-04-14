class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :code, null: false, limit: 4
      t.string :country, null: false
    end
    add_index :countries, :code, unique: true
  end
end
