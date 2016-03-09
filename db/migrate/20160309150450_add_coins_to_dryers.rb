class AddCoinsToDryers < ActiveRecord::Migration
  def change
    add_column :dryers, :coins, :integer, default: 0
  end
end
