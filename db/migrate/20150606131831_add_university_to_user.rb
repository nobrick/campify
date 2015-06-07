class AddUniversityToUser < ActiveRecord::Migration
  def change
    add_reference :users, :university, index: true, foreign_key: true
  end
end
