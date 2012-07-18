class CreateDemands < ActiveRecord::Migration
  def change
    create_table :demands do |t|
      t.string :title
      t.string :host

      t.timestamps
    end
  end
end
