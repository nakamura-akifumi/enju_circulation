class AddUserEncodingToUserImportFile < ActiveRecord::Migration[5.1]
  def change
    add_column :user_import_files, :user_encoding, :string
  end
end
