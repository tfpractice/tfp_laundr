class AddNameToLoads < ActiveRecord::Migration
  def change
    add_column :loads, :name, :string
  end
end
