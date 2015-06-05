class CreateCampusVotes < ActiveRecord::Migration
  def change
    create_table :campus_votes do |t|
      t.references :ballot, index: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :university, index: true, foreign_key: true, null: false
      t.boolean :vote_for_own_uni, index: true, default: false

      t.timestamps null: false
    end
    add_foreign_key :campus_votes, :campus_ballots, column: :ballot_id
    add_index :campus_votes, [ :ballot_id, :user_id ], unique: true
  end
end
