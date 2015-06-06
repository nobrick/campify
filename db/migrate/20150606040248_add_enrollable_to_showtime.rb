class AddEnrollableToShowtime < ActiveRecord::Migration
  def change
    add_column :showtimes, :enrollable, :boolean, default: false
    add_index :showtimes, :enrollable
  end
end
