class CreateShowtimes < ActiveRecord::Migration
  def change
    create_table :showtimes do |t|
      t.references :show, index: true, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :starts_at, index: true
      t.datetime :ends_at, index: true
      t.boolean :ongoing, default: true, index: true

      t.timestamps null: false
    end
  end
end
