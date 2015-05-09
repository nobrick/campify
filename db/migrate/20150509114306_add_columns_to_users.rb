class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :nickname, :string
    add_column :users, :gender, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :wechat_headimgurl, :string

    add_index :users, :provider
    add_index :users, :uid
    add_index :users, :nickname
    add_index :users, :gender
    add_index :users, :province
    add_index :users, :city
    add_index :users, :country
  end
end
