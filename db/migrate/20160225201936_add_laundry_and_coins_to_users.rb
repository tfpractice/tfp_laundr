class AddLaundryAndCoinsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :laundry, :decimal
    add_column :users, :coins, :integer, default: 20
  end
end
