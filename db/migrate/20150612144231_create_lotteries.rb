class CreateLotteries < ActiveRecord::Migration
  def change
    create_table :lotteries do |t|
      t.references :user, index: true, foreign_key: true, not_null: true
      t.references :lottery_event, index: true, foreign_key: true, not_null: true
      t.boolean :hit, default: false
      t.datetime :hits_at

      t.timestamps null: false
    end
    add_index :lotteries, :hit
  end
end
