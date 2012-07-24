class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.integer :demand_id
      t.integer :interface_id
      t.string :name
      t.integer :type
      t.integer :children_interface_id

      t.timestamps
    end
  end
end
