class CreateLotteryEvents < ActiveRecord::Migration
  def change
    create_table :lottery_events do |t|
      t.references :showtime, index: true, foreign_key: true, null: false
      t.datetime :draws_at, null: false
      t.string :lottery_rule, null: false
      t.integer :prizes_num, null: false
      t.string :prize_type, null: false, default: 'normal'

      t.timestamps null: false
    end
    add_index :lottery_events, :draws_at
    add_index :lottery_events, :lottery_rule
    add_index :lottery_events, :prize_type
  end
end
