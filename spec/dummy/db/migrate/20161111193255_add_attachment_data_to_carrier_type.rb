class AddAttachmentDataToCarrierType < ActiveRecord::Migration[5.1]
  def change
    add_column :carrier_types, :attachment_data, :jsonb
  end
end
