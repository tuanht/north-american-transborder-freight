class CreateModes < ActiveRecord::Migration
  def change
    create_table :modes do |t|
      t.string :code, null: false, limit: 1
      t.text :description
    end
    add_index :modes, :code, unique: true
  end
end
