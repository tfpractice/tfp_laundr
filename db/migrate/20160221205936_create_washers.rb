class CreateWashers < ActiveRecord::Migration
  def change
    create_table :washers do |t|
      t.string :name
      t.integer :position
      t.string :type
      t.string :state
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
