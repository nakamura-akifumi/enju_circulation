class AddMostRecentToEventExportFileTransitions < ActiveRecord::Migration
  def up
    add_column :event_export_file_transitions, :most_recent, :boolean, null: true
  end

  def down
    remove_column :event_export_file_transitions, :most_recent
  end
end
