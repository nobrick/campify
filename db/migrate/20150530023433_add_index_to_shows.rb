class AddIndexToShows < ActiveRecord::Migration
  def change
    add_index :shows, :created_at, order: { created_at: 'DESC' }
  end
end
