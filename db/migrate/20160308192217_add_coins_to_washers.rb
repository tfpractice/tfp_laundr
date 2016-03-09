class AddCoinsToWashers < ActiveRecord::Migration
  def change
    add_column :washers, :coins, :integer, default: 0
  end
end
