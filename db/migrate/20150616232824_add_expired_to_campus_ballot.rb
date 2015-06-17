class AddExpiredToCampusBallot < ActiveRecord::Migration
  def change
    add_column :campus_ballots, :expired, :boolean, default: false
    add_index :campus_ballots, :expired
  end
end
