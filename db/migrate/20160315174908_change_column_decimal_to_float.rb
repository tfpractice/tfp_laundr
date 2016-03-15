class ChangeColumnDecimalToFloat < ActiveRecord::Migration
  def up
    change_column :loads, :weight, :float
    change_column :users, :laundry, :float
  end

  def down
    change_column :users, :laundry, :decimal
    change_column :loads, :weight, :decimal
  end
end
