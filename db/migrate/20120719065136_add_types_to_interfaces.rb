class AddTypesToInterfaces < ActiveRecord::Migration
  def change
    add_column :interfaces, :types, :string
  end
end
