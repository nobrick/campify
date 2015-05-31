class AddColumnNotNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :enrollments, :user_id, false
    change_column_null :enrollments, :showtime_id, false

    change_column_null :shows, :name, false
    change_column_null :shows, :proposer_id, false

    change_column_null :showtimes, :show_id, false
    change_column_null :showtimes, :title, false
    change_column_null :showtimes, :starts_at, false
    change_column_null :showtimes, :ends_at, false
  end
end
