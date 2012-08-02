class RenameTypeToDemands < ActiveRecord::Migration
  def up
    rename_column :params, :type, :kind
  end

  def down
    rename_column :params, :kind, :type
  end
end
