class CreateInterfaces < ActiveRecord::Migration
  def change
    create_table :interfaces do |t|
      t.string :host
      t.string :params
      t.string :results

      t.timestamps
    end
  end
end
