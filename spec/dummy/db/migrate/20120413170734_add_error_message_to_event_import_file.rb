class AddErrorMessageToEventImportFile < ActiveRecord::Migration[5.1]
  def change
    add_column :event_import_files, :error_message, :text
  end
end
