class CreateDemandInterfaces < ActiveRecord::Migration
  def change
    create_table :demand_interfaces do |t|
      t.integer :demand_id
      t.integer :interface_id
      t.integer :child_interface_id
      t.string :params

      t.timestamps
    end
  end
end
