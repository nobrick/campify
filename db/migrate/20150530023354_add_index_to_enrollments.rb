class AddIndexToEnrollments < ActiveRecord::Migration
  def change
    add_index :enrollments, :created_at, order: { created_at: 'DESC' }
  end
end
