class CreateInterfaces < ActiveRecord::Migration
  def change
    create_table :interfaces do |t|
      t.string :host
      t.string :param
      t.string :result

      t.timestamps
    end
  end
end
