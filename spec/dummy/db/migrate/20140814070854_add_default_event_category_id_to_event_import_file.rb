class AddDefaultEventCategoryIdToEventImportFile < ActiveRecord::Migration[5.1]
  def change
    add_column :event_import_files, :default_event_category_id, :integer
  end
end
