class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :showtime, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
