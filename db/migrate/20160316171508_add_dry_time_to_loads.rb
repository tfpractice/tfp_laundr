class AddDryTimeToLoads < ActiveRecord::Migration
  def change
    add_column :loads, :dry_time, :float, default: 0
  end
end
