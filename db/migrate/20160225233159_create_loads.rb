class CreateLoads < ActiveRecord::Migration
  def change
    create_table :loads do |t|
      t.decimal :weight
      t.string :state
      t.references :user, index: true, foreign_key: true
      t.references :machine, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
