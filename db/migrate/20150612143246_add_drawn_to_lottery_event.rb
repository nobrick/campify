class AddDrawnToLotteryEvent < ActiveRecord::Migration
  def change
    add_column :lottery_events, :drawn, :boolean, default: false
    add_index :lottery_events, :drawn
  end
end
