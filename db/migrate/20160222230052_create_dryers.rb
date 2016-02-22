class CreateDryers < ActiveRecord::Migration
  def change
    create_table :dryers do |t|
      t.string :name
      t.integer :position
      t.string :state
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
