class RenameProvideToProvider < ActiveRecord::Migration[5.0]
  def change
	  rename_column :users, :provide, :provider
  end
end
