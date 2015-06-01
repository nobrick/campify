class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :location

      t.timestamps null: false
    end
  end
end
