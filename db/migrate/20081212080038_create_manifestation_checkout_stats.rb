class CreateManifestationCheckoutStats < ActiveRecord::Migration[5.1]
  def self.up
    create_table :manifestation_checkout_stats do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :manifestation_checkout_stats
  end
end
