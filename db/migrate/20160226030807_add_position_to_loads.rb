class AddPositionToLoads < ActiveRecord::Migration
  def change
    add_column :loads, :position, :integer
  end
end
