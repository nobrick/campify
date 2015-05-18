class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.string :category
      t.text :description
      t.references :proposer, index: true

      t.timestamps null: false
    end
    add_foreign_key :shows, :users, column: :proposer_id
  end
end
