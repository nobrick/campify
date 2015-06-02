class CreateCampusBallots < ActiveRecord::Migration
  def change
    create_table :campus_ballots do |t|
      t.references :showtime, index: { unique: true }, foreign_key: true, null: false
      t.datetime :expires_at, null: false

      t.timestamps null: false
    end
    add_index :campus_ballots, :expires_at
  end
end
