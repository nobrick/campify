class AddIndexToShowtimes < ActiveRecord::Migration
  def change
    add_index :showtimes, :created_at, order: { created_at: 'DESC' }
  end
end
